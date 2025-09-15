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
conda init 
conda activate ezTrack

# --- Verify the environment ---
echo "--- Verification ---"
echo "Current Python version:"
python --version

# Crop videos
#echo "Cropping the videos in individual folders from ./input/batch_test using the table in ./tables/VideoToCrop.csv"
#python scripts/CropVideo.py 1 1 800 600

# Reorganize videos for analysis
## Move all videos ending with _cropped.mkv and rename
## This step is manual for now ...

# Run the SlurmBatch script
#python LocationTracking/SlurmBatch.py
