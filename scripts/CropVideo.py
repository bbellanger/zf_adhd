# Import necessary packages
import cv2
import os
import argparse
import csv
from tqdm import tqdm

#####################################################################################

# Set the coordinates in the arguments
parser = argparse.ArgumentParser(description="Crop a video automatically.")
parser.add_argument("x1", type=int, help="x1 - From the (x1;y1) coordinates.")
parser.add_argument("y1", type=int, help="y1 - From the (x1;y1) coordinates.")
parser.add_argument("x2", type=int, help="x2 - From the (x2;y2) coordinates.")
parser.add_argument("y2", type=int, help="y2 - From the (x2;y2) coordinates.")
args = parser.parse_args()

# Confirm used arguments
print(f"Cropping videos using coordinates: ({args.x1},{args.y1}) - ({args.x2},{args.y2})")
print("Reading video list from: ./tables/VideoToCrop.csv")

#####################################################################################

# Define functions
def save_cropped_video(video_dict):
    # Original video path
    input_path = video_dict['fpath']

    # Cropping coordinates
    x1, y1, x2, y2 = video_dict['crop'].values() # Standard video frame used in the lab 
    width = x2 - x1                              # coordinates are: 1 1 800 600
    height = y2 - y1

    # Open original video
    cap = cv2.VideoCapture(input_path)
    if not cap.isOpened():
        raise ValueError(f"Cannot open video: {input_path}")

    # Video properties
    fps = cap.get(cv2.CAP_PROP_FPS)
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))  # total number of frames
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')

    # Output path
    dpath, file = video_dict['dpath'], video_dict['file']
    name, ext = os.path.splitext(file)
    output_path = os.path.join(dpath, f"{name}_cropped{ext}")

    out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

    # Process frames with tqdm progress bar
    with tqdm(total=total_frames, desc=f"Cropping {file}", unit="frame") as pbar:
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            cropped_frame = frame[y1:y2, x1:x2]
            out.write(cropped_frame)
            pbar.update(1)

    cap.release()
    out.release()
    print(f"Cropped video saved to: {output_path}")

    return output_path

#####################################################################################

# Fixed CSV file
csv_file = "./tables/VideoToCrop.csv"

# Read CSV file (expects: video_path, video_filename per row)
with open(csv_file, newline='') as csvfile:
    csv_reader = csv.reader(csvfile)
    for col in csv_reader:
        video_path = col[0]
        video_filename = col[1]

        video_dict = {
            'dpath': video_path,
            'file': video_filename,
            'fpath': os.path.join(video_path, video_filename),
            'crop': {'x1': args.x1, 'y1': args.y1, 'x2': args.x2, 'y2': args.y2}
        }

        # Save the cropped video
        save_cropped_video(video_dict)
