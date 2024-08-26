#!/bin/bash

# Base directory to start the search
base_dir="."

# Iterate through all files and directories recursively
find "$base_dir" -type f | while read -r file; do
  # Skip .git directories and files
  if [[ "$file" == *".git"* ]]; then
    continue
  fi

  # Get the last modified date of the file in YYYY-MM-DD format
  last_modified_date=$(stat -c %y "$file" | cut -d ' ' -f 1)
  
  # Format the date for git commit (RFC 3339 format: "YYYY-MM-DDTHH:MM:SS")
  last_modified_time=$(stat -c %y "$file" | cut -d ' ' -f 2 | cut -d '.' -f 1)
  commit_date="$last_modified_date $last_modified_time"

  # Check if the file has been modified
  if [[ "$last_modified_date" != "" ]]; then
    git add "$file"
    git commit -m "Committing $file based on last modified time $last_modified_date" --date="$commit_date"
    echo "Committed $file with date $commit_date"
  fi
done
