#!/bin/bash
docker inspect --format='{{.RepoDigests}}' "$1" | sed -r 's/\[checkmarx\/kics@(sha256:)(.*)\]/\1\2/g'
