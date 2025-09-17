#!/bin/bash

echo "
                                                                                                     @@@@@@
                                                                                                   @@@@@@@@
                                                @@@@@ %@@@                                     @@@@@@@@
                                                   @ :@ @@@@                               @@@@@@@@@
                                                :@@@@@#+@@@@@=                         *@@@@@@@@@
                                                 @@@@@#@*%@@@@@                    =@@@@@@@@@+
                                                  @@+@*%@@@@@@@@@%**@@@@%%#*  +*@@@@@@@@@@@
                                                  @%.@@@@@@@@@@@@@@@@@@@@@@%@%% :#@@@@@@@@
                                                   @@@@@@@+@@@@@@@@@@@@@@@*%@%+:---- =@@@@@@@@@
                                                  =@@@@@@@@@@@@@@@@@@%@@%  @@@.@@@@@@@@@@@@@
                                                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                                       @@@@@@@@@@@@@@@@@@@@@@@@
                                                         @@@@@@@@@@@@@@@@@@@
                                                             @@@@@@@@@@@@@@@
                                                                  @@ @ @@@@%#
                                                                  .@    @@
                                                                      @@
                                                    @@    @   @@    @@
                                                                   *@@@@#

                                                                        #
                                                                  :@    =@%=
                                                             =-#@%*@##%%#@@@

"

# --- Parse command line arguments ---
while getopts "a:b:c:" opt; do
  case "$opt" in
    a) param_a="$OPTARG" ;;
    b) param_b="$OPTARG" ;;
    c) param_c="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# Debugging: Show values
echo "Parameter A (video path): $param_a"
echo "Parameter B (video filename): $param_b"
echo "Parameter C (new name): $param_c"

# --- Check required parameters ---
if [[ -z "$param_a" || -z "$param_b" ]]; then
  echo "❌ Error: Both -a (video path) and -b (video filename) are required."
  exit 1
fi

# --- Activate the ezTrack conda environment ---
source /home/corvus/anaconda3/etc/profile.d/conda.sh
conda activate ezTrack

# --- Verify the environment ---
echo "--- Verification ---"
echo "Current Python version:"
python --version

# --- Crop the video ---
echo "--- Cropping the video ---"
echo "Running: python ./scripts/Crop1Video.py \"$param_a\" \"$param_b\" 1 1 800 600"
python ./scripts/Crop1Video.py "$param_a" "${param_b}.mkv" 1 1 800 600

# --- Rename the video ---
if [[ -n "$param_c" ]]; then
  echo "--- Renaming cropped video ---"
  input_file="${param_a}${param_b}_cropped.mkv"
  output_file="${param_a}${param_c}.mkv"
  if [[ -f "$input_file" ]]; then
    mv "$input_file" "$output_file"
    echo "✅ Renamed: $input_file → $output_file"
  else
    echo "❌ File not found: $input_file"
  fi
else
  echo "ℹ️ Skipping rename (no -c argument given)."
fi

# Remove the original video
echo "Removing the original, uncropped video: {param_a}${param_b}.mkv"
#rm "${param_a}${param_b}.mkv"

# --- Tracking analysis on the video ---
echo "--- Running tracking analysis on the corresponding folder ---"
python LocationTracking/SlurmBatch.py "$param_a"
