use tapasco::tlkm::*;
use clap::Parser;
use std::path::PathBuf;
use std::collections::HashMap;
use thiserror::Error;
use std::fs::File;
use std::io::prelude::*;
use std::collections::HashSet;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    #[arg(short, long, default_value_t = 0x00000000)]
    addr: u64,
}

#[derive(Error, Debug)]
pub enum TestError {
    #[error("io error")]
    IO(#[from] std::io::Error),
    #[error("utf8 error")]
    UTF8(#[from] std::string::FromUtf8Error),
    #[error("Allocator Error")]
    Allocator(#[from] tapasco::allocator::Error),
    #[error("DMA Error")]
    DMA(#[from] tapasco::dma::Error),
    #[error("Failed to initialize TLKM object")]
    TLKMInit(#[from] tapasco::tlkm::Error),
    #[error("Failed to decode TLKM device")]
    DeviceInit(#[from] tapasco::device::Error),
    #[error("Error while executing Job")]
    JobError(#[from] tapasco::job::Error),
}

fn main() -> Result<(), TestError> {
    let cli = Cli::parse();
    let tlkm = TLKM::new()?;
    println!("TLKM version is {}", tlkm.version()?);
    let mut device = &mut tlkm.device_enum(&HashMap::new())?[0];

    println!(
        "Device {}: Name: {}, Vendor: {}, Product {}",
        device.id(),
        device.name(),
        device.vendor(),
        device.product(),
    );
    device.change_access(tapasco::tlkm::tlkm_access::TlkmAccessExclusive)?;

    let pe_id = device.get_pe_id("sus:suspmv:suspmv:1.0")?;
    let mut pe = device.acquire_pe(pe_id)?;

    println!("start");
    pe.start(vec![
        tapasco::device::PEParameter::Single64(cli.addr),     // start_addr
    ])?;

    let (result, output) = pe.release(true, false)?;
    println!("done {:?}", result);

    println!("exit");
    Ok(())
}