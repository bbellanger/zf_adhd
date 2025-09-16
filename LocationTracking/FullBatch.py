# This script runs a tracking analysis on videos from individual folders in ./input/batch/

# Import necessary packages
import os
import numpy as np
import pandas as pd
import LocationTracking_Functions_standalone as lt

# Define a folder_list to loop through
folder_list = []
directory_path = "./input"

for item in os.listdir(directory_path):
    item_path = os.path.join(directory_path, item)
    if os.path.isdir(item_path):
        folder_list.append(item)

print(f"Tracking videos from the following folders: {folder_list}")

# Tracking parameters
## Define video parameters in a for loop instead
for folder in folder_list :
    video_dict = {
        'dpath' : f"./input/{folder}",
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
