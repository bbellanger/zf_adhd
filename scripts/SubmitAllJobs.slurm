#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=32000
#SBATCH -t 01:00:00
#SBATCH -o logfiles/ezTrack_%a.log
#SBATCH --array 1-1
#SBATCH -p standard
#SBATCH -A melizalab

# --- Load the mamba environment
set -e
module load miniforge
source activate ezTrack
PYTHON=${HOME}/.conda/envs/ezTrack/bin/python3

# --- Verify the environment ---
echo "--- Verification ---"
echo "Current Python version:"
${PYTHON} --version
which python

# --- Setup directories ---
OUTDIR="build"
mkdir -p ${OUTDIR}

DATASET_DIR="input/"
CONTROL_FILE="input/cropandtrack_tasks.txt"

# --- Read task from control file ---
read ANIMAL_ID FILENAME <<< "$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$CONTROL_FILE")"

echo "Processing ANIMAL_ID: ${ANIMAL_ID}, FILENAME: ${FILENAME}"

# --- Crop the video ---
echo "--- Cropping video ---"
${PYTHON} scripts/Crop1Video.py "${DATASET_DIR}" "${FILENAME}.mkv" 1 1 800 600

if [[ $? -ne 0 ]]; then
  echo "ERROR: Cropping failed!"
  exit 1
fi

# --- Organize the build directory (nested structure required for tracking) ---
mkdir -p "${OUTDIR}/${ANIMAL_ID}/${ANIMAL_ID}"
mv "${DATASET_DIR}${FILENAME}_cropped.mkv" "${OUTDIR}/${ANIMAL_ID}/${ANIMAL_ID}/${ANIMAL_ID}.mkv"

echo "SUCCESS: Created ${OUTDIR}/${ANIMAL_ID}/${ANIMAL_ID}/${ANIMAL_ID}.mkv for tracking."

# --- Remove original file ---
if [[ -f "${DATASET_DIR}${FILENAME}.mkv" ]]; then
  echo "Removing original file: ${DATASET_DIR}${FILENAME}.mkv"
  rm "${DATASET_DIR}${FILENAME}.mkv"
  echo "SUCCESS: Original file removed"
fi

# --- Tracking analysis ---
echo "--- Running tracking analysis ---"
#${PYTHON} LocationTracking/FullBatch.py   Obsolete
${PYTHON} LocationTracking/FullBatch.py "${OUTDIR}/${ANIMAL_ID}/"
