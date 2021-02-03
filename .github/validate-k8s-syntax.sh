#!/usr/bin/env bash
set -eo pipefail;
KUBEVAL_PATH=${KUBEVAL_PATH:-'.bin/kubeval'}

for filepath in $(find assets/queries/k8s -type f -name '*.yaml' -or -name '*.yml' $(printf "! -path %s " $(cat .github/validate-k8s-skip-list))); do
  echo "Validating ${filepath}"
  #kubectl apply --dry-run=client --validate=true -f "${filepath}"
  command "${KUBEVAL_PATH}" "${filepath}"
done
