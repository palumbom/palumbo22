#!/bin/bash
#SBATCH -A ebf11_c
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=48:00:00
#SBATCH --job-name=showyourwork
#SBATCH --chdir=/storage/home/mlp95/work/palumbo22
#SBATCH --output=/storage/home/mlp95/work/logs/showyourwork.%j.out

echo "About to start: $SLURM_JOB_NAME"
date
echo "Job id: $SLURM_JOBID"
echo "About to change into $SLURM_SUBMIT_DIR"
cd $SLURM_SUBMIT_DIR
echo "About to start showyourwork"
showyourwork clean --force
showyourwork cache delete
showyourwork cache create
showyourwork build --cores 4 --profile ./profile/simple/
echo "showyourwork exited"
date


