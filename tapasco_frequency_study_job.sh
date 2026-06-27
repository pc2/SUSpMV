#!/bin/bash
#SBATCH -t 12:00:00
#SBATCH --array=0-0
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=8G
#SBATCH -J tapasco_frequency_study_jobs
#SBATCH -A pc2-mitarbeiter
#SBATCH -p largemem
#SBATCH -q fpgasynthesis

source u280_tapasco_modules.sh
source ../otus/tapasco-workdir/tapasco-setup.sh

cd fpga_builds

# List of design frequencies (one per array task)
FREQUENCIES=(
    250
    300
    350
    375
    390
    400
    410
    420
    425
    450
)

FREQ=${FREQUENCIES[$SLURM_ARRAY_TASK_ID]}

TMP_JOBFILE="job_tapasco_${FREQ}MHz.json"

cp ../tapasco/job_au280.json "$TMP_JOBFILE"

sed -i -E \
    's/"Design Frequency"[[:space:]]*:[[:space:]]*[0-9]+/"Design Frequency": '"$FREQ"'/' \
    "$TMP_JOBFILE"

echo "Running with Design Frequency = $FREQ MHz"

tapasco --jobsFile "$TMP_JOBFILE"
