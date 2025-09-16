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

# Activate the ezTrack conda environment
#conda init
source /home/corvus/anaconda3/etc/profile.d/conda.sh # Initialize Conda properly for this shell session
conda activate ezTrack

# --- Verify the environment ---
echo "--- Verification ---"
echo "Current Python version:"
python --version

# Crop videos
echo "Cropping the videos in individual folders from ./input/batch_test using the table in ./tables/VideoToCrop.csv"
#python scripts/CropVideo.py 1 1 800 600

# Reorganize videos for analysis
## Move all videos not ending with _cropped.mkv and rename _cropped.mkv
find ./input/*/ -type f -name "*.mkv" ! -name "*_cropped.mkv" -delete
python RenameCroppedVideos.py

# Run the FullBatch script
python LocationTracking/FullBatch.py
