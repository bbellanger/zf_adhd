#!/bin/bash
#SBATCH --job-name=eztrack_setup
#SBATCH --time=00:10:00
#SBATCH --mem=2G

module load anaconda

# Initialize conda in this shell
source ~/anaconda3/etc/profile.d/conda.sh

# Create the env (only do this once)
conda create -y -n ezTrack \
  -c conda-forge \
  python=3.6 \
  pandas=0.23.0 \
  matplotlib=3.1.1 \
  opencv=3.4.3 \
  holoviews=1.13.5 \
  scipy=1.2.1 \
  bokeh=2.1.1 \
  tqdm
