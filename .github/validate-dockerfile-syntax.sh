#!/usr/bin/env bash
set -eo pipefail;
HADOLINT_PATH=${HADOLINT_PATH:-'.bin/hadolint'}

for filepath in $(find assets/queries/dockerfile -type f -name '*.dockerfile'); do
  echo "Validating ${filepath}"
  command "${HADOLINT_PATH}" -c ".github/hadolint.yml" "${filepath}";
done
