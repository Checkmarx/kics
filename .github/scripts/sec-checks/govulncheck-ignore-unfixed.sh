#!/bin/bash

# Last reviewed for govulncheck version 1.0.4

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"

# Check if "./results.txt" exists and isn't empty
if [[ ! -f "./results.txt" || -z "$(cat ./results.txt)" ]]; then
  echo -e "${RED}Error: './results.txt' is empty or doesn't exist."
  exit 1
fi

# Define ignored vulnerability IDs
IGNORED_IDS=("GO-2025-3660, GO-2022-0646, GO-2022-0635")

# Convert ignore list to grep pattern (e.g., "GO-2025-3660|GO-2024-1234")
IGNORE_PATTERN=$(IFS="|"; echo "${IGNORED_IDS[*]}")

# Initialize variables
filtered_output=""
block=""
skip=0
ignored_count=0

# Process results.txt line by line
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ ^Vulnerability\ #[0-9]+:\ (GO-[0-9]{4}-[0-9]+) ]]; then
    # If we already have a block and it wasn’t skipped, keep it
    if [[ -n $block && $skip -eq 0 ]]; then
      filtered_output+="$block"$'\n'
    fi

    block="$line"$'\n'
    vuln_id="${BASH_REMATCH[1]}"

    if [[ $vuln_id =~ $IGNORE_PATTERN ]]; then
      skip=1
      ((ignored_count++))
    else
      skip=0
    fi
  elif [[ -z $line ]]; then
    if [[ -n $block && $skip -eq 0 ]]; then
      filtered_output+="$block"$'\n'
    fi
    block=""
  else
    block+="$line"$'\n'
  fi
done < ./results.txt

# Add the last block if not skipped
if [[ -n $block && $skip -eq 0 ]]; then
  filtered_output+="$block"$'\n'
fi

# Initialize counters with zero vulnerabilities
vuln_count=0
unfixed_count=0

# Loop through each line in the output
while IFS= read -r line; do
  # Check for "Found in:" and increment vulnerability count
  if [[ $line =~ "Found in:" ]]; then
    ((vuln_count++))
  fi

  # Check for "Fixed in: N/A" and increment unfixed count
  if [[ $line =~ "Fixed in: N/A" ]]; then
    ((unfixed_count++))
  fi
done <<< "$filtered_output"

# Print findings and exit with appropriate code
if [[ $vuln_count -eq 0 ]]; then
  if grep -q "No vulnerabilities found." <<< "$filtered_output"; then
    echo -e "${GREEN}No vulnerabilities found."
  else
    echo -e "${YELLOW}All vulnerabilities were ignored (ignored: $IGNORE_PATTERN)."
  fi
  exit 0
elif [[ $vuln_count -eq $unfixed_count ]]; then
  echo -e "${YELLOW}All found vulnerabilities ($vuln_count) have no fix available."
  ((ignored_count > 0)) && echo -e "${YELLOW}$ignored_count vulnerabilities were ignored."
  exit 0
else
  echo -e "${RED}Found $vuln_count vulnerabilities, $unfixed_count without available fixes."
  ((ignored_count > 0)) && echo -e "${YELLOW}$ignored_count vulnerabilities were ignored."
  exit 1
fi
