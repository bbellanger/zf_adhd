import os
import sys
import csv
import glob

# Path to the CSV file
csv_file = "./tables/video_id.csv"

# Pattern to find all cropped video files in subdirectories of ./input/
cropped_videos_pattern = "./input/*/"

try:
    with open(csv_file, newline='') as csvfile:
        csv_reader = csv.reader(csvfile)
        renamed_count = 0
        missing_files = []

        for row in csv_reader:
            if len(row) >= 6:
                cropped_filename = row[5] + ".mkv"
                new_name = row[0]

                # Search all matching files in the subdirectories
                matching_files = glob.glob(os.path.join(cropped_videos_pattern, cropped_filename))

                if matching_files:
                    original_path = matching_files[0]  # use the first match
                    directory = os.path.dirname(original_path)
                    new_path = os.path.join(directory, f"{new_name}.mkv")

                    os.rename(original_path, new_path)
                    print(f"Renamed: '{cropped_filename}' → '{new_name}.mkv'")
                    renamed_count += 1
                else:
                    print(f"File not found: '{cropped_filename}'")
                    missing_files.append(cropped_filename)

        print(f"\nDone. Renamed {renamed_count} files.")
        if missing_files:
            print(f"{len(missing_files)} files were not found:")
            for f in missing_files:
                print(f"  - {f}")

except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(1)
