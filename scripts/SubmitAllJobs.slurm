#!/bin/bash
#SBATCH --job-name=crop_batch
#SBATCH --output=logs/slurm_%A_%a.out
#SBATCH --error=logs/slurm_%A_%a.err
#SBATCH --array=1-$(wc -l < tables/video_id.csv)
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=2

# --- Load necessary modules / environment if needed ---
module load anaconda

# --- Read the right line from the CSV ---
line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" tables/video_id.csv)

# --- Parse CSV line ---
IFS=',' read -r video_path timestamp video_filename context treatment new_name <<< "$line"

# --- Set full video path ---
video_path="input/${id}/"

# --- Debug output ---
echo "Processing video:"
echo "- ID:           $new_name"
echo "- Path:         $video_path"
echo "- File:         $video_filename"
echo "- New name:     $new_name"

# --- Run the actual processing script ---
bash scripts/SlurmBash.sh -a "$video_path" -b "$video_filename" -c "$new_name"
