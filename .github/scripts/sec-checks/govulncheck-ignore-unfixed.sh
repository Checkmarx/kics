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

# Read the output of govulncheck
output=$(cat ./results.txt)

# Initialize counters with zero vulnerabilities
vuln_count=0
unfixed_count=0

# Loop through each line in the output
while read -r line; do
  # Check for "Found in:" and increment vulnerability count
  if [[ $line =~ "Found in:" ]]; then
    ((vuln_count++))
  fi

  # Check for "Fixed in: N/A" and increment unfixed count
  if [[ $line =~ "Fixed in: N/A" ]]; then
    ((unfixed_count++))
  fi
done <<< "$output"

# Print findings and exit with appropriate code
if [[ $vuln_count -eq 0 ]]; then
  if grep -q "No vulnerabilities found." <<< "$output"; then
    echo -e "${GREEN}No vulnerabilities found."
    exit 0
  else
    echo -e "${RED}Unexpected results! The bash script needs to be updated."
    exit 1
  fi
elif [[ $vuln_count -eq $unfixed_count ]]; then
  echo -e "${YELLOW}All found vulnerabilities ($vuln_count) have no fix available."
  exit 0
else
  echo -e "${RED}Found $vuln_count vulnerabilities, $unfixed_count without available fixes."
  exit 1
fi
