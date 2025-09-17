# This script runs a tracking analysis videos conainted in folder (argument)

# Import necessary packages
import os
#import numpy as np
#import pandas as pd
import cv2
import argparse
#import csv
from tqdm import tqdm
import LocationTracking_Functions_standalone as lt

# Set the folder as an argument
parser = argparse.ArgumentParser(description="Track the animal in videos from a given folder.")
parser.add_argument("folder", type=str, help="folder- Folder containing the videos to analyze.")
args = parser.parse_args()

# Set input argument as a variable
folder = args.folder

# Tracking parameters
## Define video parameters in a for loop instead
video_dict = {
    'dpath' : f"{folder}",
    'ftype' : 'mkv',
    'start' : 36000,                      # Starting at 10 minutes, assuming 60 frames/sec
    'end' : 160000,                       # Ending at 55 minutes, assuming 60 frames/sec
    'dsmpl' : 1,
    'stretch' : dict(width=1, height=1)
}
#define parameters for location tracking
tracking_params = {
    'loc_thresh'    : 99, 
    'use_window'    : True, 
    'window_size'   : 100, 
    'window_weight' : .9, 
    'method'        : 'abs',
    'rmv_wire'      : False, 
    'wire_krn'      : 10
}

#set bin_dict
#set bin_dict = None if only overall session average is desired
bin_dict = {
    '1' : (0,10),
    '2' : (10,20),
    '3' : (20,30)
}

#code below loads folder with files.  
video_dict = lt.Batch_LoadFiles(video_dict)
video_dict['FileNames']

summary, images = lt.Batch_Process(video_dict,tracking_params,bin_dict)
