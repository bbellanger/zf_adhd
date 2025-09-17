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

# --- Parse the CSV line ---
IFS=',' read -r id timestamp _ _ _ _ <<< "$line"

# --- Construct video path ---
video_path="./input/${id}/"

# --- Use timestamp as filename (quoted), id as new name ---
video_filename="$timestamp"
new_name="$id"

# --- Debug info ---
echo "Processing video:"
echo "- ID (new name):    $new_name"
echo "- Folder path:      $video_path"
echo "- Video filename:   $video_filename"

# --- Run SlurmBash.sh with quoted filename ---
bash scripts/SlurmBash.sh -a "$video_path" -b "$video_filename" -c "$new_name"
