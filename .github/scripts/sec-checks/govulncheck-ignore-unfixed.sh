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
IGNORED_IDS=("GO-2025-3660")

# Convert ignore list to grep pattern (e.g., "GO-2025-3660|GO-2024-1234")
IGNORE_PATTERN=$(IFS="|"; echo "${IGNORED_IDS[*]}")

# Filter the results: remove blocks starting with an ignored ID
filtered_output=$(awk -v pattern="$IGNORE_PATTERN" '
  /^Vulnerability ID:/ {
    block = $0 "\n"
    if ($3 ~ pattern) {
      skip = 1
    } else {
      skip = 0
    }
    next
  }
  {
    if (skip) next
    if (/^$/) {
      if (!skip && block != "") print block
      block = ""
    } else {
      block = block $0 "\n"
    }
  }
  END {
    if (!skip && block != "") print block
  }
' ./results.txt)

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
done <<< "$filtered_output"

# Print findings and exit with appropriate code
if [[ $vuln_count -eq 0 ]]; then
  if grep -q "No vulnerabilities found." <<< "$filtered_output"; then
    echo -e "${GREEN}No vulnerabilities found."
    exit 0
  else
    echo -e "${YELLOW}All vulnerabilities were ignored (ignored: $IGNORE_PATTERN)."
    exit 0
  fi
elif [[ $vuln_count -eq $unfixed_count ]]; then
  echo -e "${YELLOW}All found vulnerabilities ($vuln_count) have no fix available."
  exit 0
else
  echo -e "${RED}Found $vuln_count vulnerabilities, $unfixed_count without available fixes."
  exit 1
fi
