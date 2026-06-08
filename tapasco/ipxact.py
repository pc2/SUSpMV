import os
import shutil
import subprocess
import argparse


class Core:

    def __init__(self, name, top_module, top_module_file, verilog_dir):
        if name is None:
            raise Exception('name missing')
        if top_module is None:
            top_module = name
        if top_module_file is None:
            top_module_file = f'{top_module}.v'
        if not os.path.exists(top_module_file):
            raise Exception(f'file {top_module_file} does not exist')

        self.top_module = top_module
        self.top_module_file = top_module_file
        self.name = name
        self.vendor = "sus"
        self.library = 'suspmv'
        self.version = '1.0'
        self.files = []
        self.verilog_dir = verilog_dir


def to_ipxact(core: Core) -> str:
    top_module_file = core.top_module_file
    top_module = core.top_module
    name = core.name
    vendor = core.vendor
    library = core.library
    version = core.version
    files = core.files

    target = f'ipxact/{name}.zip'
    os.makedirs('ipxact', exist_ok=True)
    if os.path.exists('ipxact/verilog'):
        shutil.rmtree('ipxact/verilog')
    os.mkdir('ipxact/verilog')
    os.mkdir(f'ipxact/{name}')

    shutil.copy(top_module_file, os.path.join('ipxact/verilog', os.path.split(top_module_file)[1]))
    if core.verilog_dir:
        shutil.copytree(core.verilog_dir, os.path.join('ipxact/verilog/'), dirs_exist_ok=True)

    for file, path in files:
        shutil.copy(file, os.path.join('ipxact/verilog', path))

    shutil.copytree('ipxact/verilog', f'ipxact/{name}/verilog')

    tcl = f"""
ipx::infer_core -vendor {vendor} -name {name} -library {library} -version {version} -taxonomy /UserIP -files verilog/{os.path.split(top_module_file)[1]} -root_dir ./
ipx::edit_ip_in_project -upgrade true -name edit_ip_project -directory ./ {name}/component.xml
ipx::current_core {name}/component.xml
set_property top {top_module} [current_fileset]
set_property -quiet interface_mode monitor [ipx::get_bus_interfaces *MON* -of_objects [ipx::current_core]]
add_files verilog/
update_compile_order -fileset sources_1
set_property name {name} [ipx::current_core]
set_property display_name {name} [ipx::current_core]
set_property description {name} [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
set_property supported_families {{zynq Pre-Production virtex7 Pre-Production kintex7 Pre-Production artix7 Pre-Production zynquplus Pre-Production virtex7 Pre-Production qvirtex7 Pre-Production kintex7 Pre-Production kintex7l Pre-Production qkintex7 Pre-Production qkintex7l Pre-Production artix7 Pre-Production artix7l Pre-Production aartix7 Pre-Production qartix7 Pre-Production zynq Pre-Production qzynq Pre-Production azynq Pre-Production spartan7 Pre-Production virtexu Pre-Production virtexuplus Pre-Production virtexuplusHBM Pre-Production kintexuplus Pre-Production zynquplus Pre-Production kintexu Pre-Production versal Pre-Production}} [ipx::current_core]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
ipx::merge_project_changes files [ipx::current_core]
ipx::merge_project_changes ports [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project -delete
puts "VIVADO FINISHED SUCCESSFULLY"
"""
    with open(f'ipxact/{name}/tmp.tcl', 'w') as file:
        file.write(tcl)

    cmd = ['vivado', '-mode', 'batch', '-source', 'tmp.tcl', '-nojournal', '-nolog']
    print(f'run: {" ".join(cmd)}')
    process = subprocess.Popen(cmd, cwd=f'ipxact/{name}')
    process.communicate()

    shutil.rmtree(f'ipxact/verilog')
    shutil.rmtree(f'ipxact/{name}/.Xil')
    shutil.rmtree(f'ipxact/{name}/{name}')
    os.remove(f'ipxact/{name}/tmp.tcl')

    cmd = ['zip', '-r0T', f'{name}.zip', f'{name}/']
    print(f'run: {" ".join(cmd)}')
    process = subprocess.Popen(cmd, cwd='ipxact')
    process.communicate()

    shutil.rmtree(f'ipxact/{name}')
    return target


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        prog='ipxact',
        description='converts a verilog module into ipxact using vivado'
    )
    parser.add_argument('-n', '--name')
    parser.add_argument('-t', '--top')
    parser.add_argument('-f', '--file')
    parser.add_argument('-d', '--dir')
    args = parser.parse_args()

    core = Core(args.name, args.top, args.file, args.dir)
    to_ipxact(core)
