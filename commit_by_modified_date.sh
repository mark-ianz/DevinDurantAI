#!/bin/bash

# Base directory to start the search
base_dir="."

# Iterate through all files and directories recursively
find "$base_dir" -type f -or -type d | while read -r path; do
  # Skip the script file itself
  if [[ "$path" == "$(realpath "$0")" ]]; then
    continue
  fi

  # Get the last modified date of the path
  last_modified_date=$(stat -c %y "$path" | cut -d ' ' -f 1)

  # Commit the file or directory if it has been modified
  if [[ "$last_modified_date" != "" ]]; then
    git add "$path"
    git commit -m "Committing $path based on last modified time $last_modified_date"
  fi
done
