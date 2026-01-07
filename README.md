# ZF_ADHD

Automated zebrafish behavioral video tracking pipeline using ezTrack and SLURM for parallel processing.

## Overview

**zf_adhd** is a high-throughput video tracking system designed for zebrafish behavioral experiments. It leverages [ezTrack](https://github.com/denisecailab/ezTrack) for automated tracking and includes custom wrapper scripts optimized for SLURM cluster environments.

### Key Features

- 🎯 Automated animal location tracking during behavioral tasks
- 🚀 Parallel video processing using SLURM job arrays
- ✂️ Customizable video cropping capabilities
- 📊 Batch processing support for multiple videos

### Limitations

- **Designed for location tracking only** — not suitable for freezing behavior analysis
- Requires SLURM-enabled computing environment for parallel processing

---

## Prerequisites

- Access to a SLURM-managed computing cluster
- Mamba or Conda package manager
- Python 3.9.16

---

## Installation

### Why Mamba?

The original ezTrack installation uses conda, which can be slow and prone to conflicts in SLURM environments. We recommend using **mamba** for faster, more reliable dependency resolution.

### Install Dependencies

```bash
mamba create -y -n ezTrack -c conda-forge \
  python=3.9.16 \
  jupyter=1.0.0 \
  numpy=1.24 \
  scipy=1.11.1 \
  pandas=2.0.3 \
  opencv=4.7.0 \
  holoviews=1.15.0 \
  bokeh=2.4.0 \
  pyviz_comms=2.1 \
  jinja2=3.1.2 \
  scikit-learn=1.3.0 \
  matplotlib=3.7.2 \
  tqdm=4.65.0 \
  opencv-python-headless
```

### Activate Environment

```bash
conda activate ezTrack
```

---

## Setup

### 1. Prepare Your Videos

Transfer all videos to be analyzed into the `./input` directory:

```bash
mv /path/to/your/videos/*.mkv ./input/
```

### 2. Create Task List

Edit `./input/cropandtrack_tasks.txt` to specify which videos to analyze:

**Format:**
```
Animal_ID    Filename
```

**Example:**
```
Rb331_test   test
Rb331_01     Rb331_20250819_baseline
Rb331_02     Rb331_20250819_noise
Rb331_03     Rb331_20250819_recovery
```

> **Note:** Use tabs or spaces consistently for separation

### 3. Configure Video Cropping

Edit the cropping parameters in `./scripts/SubmitAllJobs.slurm` to match your experimental setup:

```bash
# --- Crop the video ---
echo "--- Cropping video ---"
${PYTHON} scripts/Crop1Video.py "${DATASET_DIR}" "${FILENAME}.mkv" 1 1 800 600
```

**Cropping parameters:** `x1 y1 x2 y2`
- `x1, y1`: Top-left corner coordinates (in pixels)
- `x2, y2`: Bottom-right corner coordinates (in pixels)

**Example:** `1 1 800 600` crops a region from (1,1) to (800,600)

### 4. Configure SLURM Settings

Adjust the SLURM job parameters in `./scripts/SubmitAllJobs.slurm` according to your cluster and dataset:

```bash
#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=32000                 # Memory in MB
#SBATCH -t 02:00:00                 # Max runtime (HH:MM:SS)
#SBATCH -o logfiles/ezTrack_%a.log  # Log file location
#SBATCH --array 1-25                # Number of videos to process
#SBATCH -p standard                 # Partition name
#SBATCH -A mylab                    # Your SLURM account
```

> **Important:** Update `--array 1-N` where N = total number of videos in your task list

---

## Usage

### Run Tracking Pipeline

Submit all video tracking jobs in parallel:

```bash
sbatch scripts/SubmitAllJobs.slurm
```

### Monitor Job Progress

Check the status of your jobs:

```bash
squeue -u $USER
```

View log files:

```bash
tail -f logfiles/ezTrack_*.log
```

### Cancel Jobs

If needed, cancel all running jobs:

```bash
scancel -u $USER
```

---

## Output

Tracking results will be saved in the designated output directory (configured in your scripts). Typical outputs include:

- Cropped video files
- Tracking coordinates (CSV format)
- Tracking visualization videos
- Summary statistics

---

## Troubleshooting

### Common Issues

**Problem:** Jobs fail with memory errors  
**Solution:** Increase `--mem` parameter in SLURM script

**Problem:** Jobs timeout before completion  
**Solution:** Increase `-t` runtime parameter

**Problem:** Environment activation fails  
**Solution:** Ensure mamba/conda is properly initialized:
```bash
conda init bash
source ~/.bashrc
```

---

## Future Development

### In Progress

- 📈 R-based plotting and statistical analysis scripts
- 📋 Automated quality control checks
- 🔄 Integration with additional tracking algorithms

### Planned Features

- Support for freezing behavior analysis
- Interactive visualization dashboard
- Automated report generation

---

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

---

## License

This project builds upon [ezTrack](https://github.com/denisecailab/ezTrack). Please refer to the original ezTrack repository for licensing information.

---

## Citation

If you use this pipeline in your research, please cite the original ezTrack paper:

> Pennington ZT, et al. (2019). ezTrack: An open-source video analysis pipeline for the investigation of animal behavior. *Scientific Reports*, 9(1), 19979.

---

## Contact

For questions or issues, please open an issue on the GitHub repository or contact the project maintainers.
