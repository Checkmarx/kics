#!/usr/bin/env bash
CHANGES=$(git log --oneline $(git describe --tags --match 'nightly' --abbrev=0)..HEAD)
if [[ -n ${CHANGES} ]]; then
  echo true
else
  echo false
fi
