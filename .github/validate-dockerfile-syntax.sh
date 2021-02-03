#!/bin/bash
set -eo pipefail;
MOUNT_ROOT=${MOUNT_ROOT:-'/project'}

echo assets/queries/dockerfile/**/*.dockerfile
for filepath in $(find assets/queries/dockerfile -type f -name '*.dockerfile'); do
  echo "Validating ${filepath}"
  docker run -v $(pwd):${MOUNT_ROOT} hadolint/hadolint hadolint -c "${MOUNT_ROOT}/.github/hadolint.yml" "${MOUNT_ROOT}/$filepath";
done
