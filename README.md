## ezTrack Installation

### **Option 1**: Download Miniconda/Anaconda
Installation of ezTrack requires the user to download the free package management system Miniconda or its larger counterpart Anaconda [https:// www.anaconda.com](https:// www.anaconda.com). For those with minimal programming experience, using the PKG installer is likely to be more intuitive.

- If using the linux terminal:

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2025.08-Linux-x86_64.sh # Or link to the latest version
```

- Verify the installer (optionnal but recommended).

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2025.08-Linux-x86_64.sh
```

Compare to the output with the checksum on the Anaconda website.

- Run the installer.

```bash
bash Anaconda3-2025.08-Linux-x86_64.sh
```

- Initialize conda.

```bash
~/anaconda3/bin/conda init
```

### Create ezTrack environment

After installing Miniconda/Anaconda, the user can create the ezTrack Conda environment, which will contain all of the package dependencies necessary for ezTrack to run. This is achieved by entering the following command into one’s Terminal (on OSX/Linux) or Anaconda Prompt (on Windows): 

```bash
conda create -y -n ezTrack -c conda-forge python=3.6 pandas=0.23.0 matplotlib=3.1.1 opencv=3.4.3 jupyter=1.0.0 holoviews=1.13.5 scipy=1.2.1 bokeh=2.1.1 tqdm
```

- To activate the environment:

```bash
conda activate ezTrack
```

- And to deactivate:

```bash
conda deactivate
```

## Slurm

Make sure the folder structure exist for every line of the video_id.csv file.

```bash
mkdir -p logs/
```

Submit the job to Rivanna using Slurm

```bash
sbatch scripts/SubmitAllJobs.slurm
```


