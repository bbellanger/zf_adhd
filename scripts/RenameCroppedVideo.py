import os
import sys
import csv

# Check arguments
if len(sys.argv) != 3:
    print("Usage: python RenameCroppedFiles.py <file_path> <cropped_filename>")
    sys.exit(1)

file_path = sys.argv[1]  # Full path to the file
cropped_filename = sys.argv[2]  # Filename to search for in the CSV (column 5)

# Path to the CSV file
csv_file = "./tables/video_id.csv"

# Read the CSV and find the matching row
new_name = None

try:
    with open(csv_file, newline='') as csvfile:
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if len(row) >= 6 and row[5] == cropped_filename:
                new_name = row[0]
                break

    if not new_name:
        print(f"Error: No entry found in CSV for filename '{cropped_filename}'")
        sys.exit(1)

    # Check if the original file exists
    if not os.path.isfile(file_path):
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)

    # Get the directory and rename with new name + .mkv
    directory = os.path.dirname(file_path)
    new_path = os.path.join(directory, f"{new_name}.mkv")

    os.rename(file_path, new_path)
    print(f"Success: Renamed '{file_path}' → '{new_path}'")

except Exception as e:
    print(f"Unexpected error: {e}")
    sys.exit(1)
