#!/bin/bash

# Base directory to start the search
base_dir="."

# Iterate through all files and directories recursively
find "$base_dir" -type f -or -type d | while read -r path; do
  # Skip .git directories and files
  if [[ "$path" == *".git"* ]]; then
    continue
  fi

  # Get the last modified date of the path
  last_modified_date=$(stat -c %y "$path" | cut -d ' ' -f 1)

  # Check if the file or directory has been modified
  if [[ "$last_modified_date" != "" ]]; then
    # Check if the path is already staged or committed
    if git ls-files --stage | grep -q "$(basename "$path")"; then
      echo "$path is already staged or committed."
    else
      git add "$path"
      git commit -m "Committing $path based on last modified time $last_modified_date"
      echo "Committed $path with date $last_modified_date"
    fi
  fi
done
