#!/usr/bin/env zsh

list_cfn_samples() {
  for sample in assets/queries/cloudFormation/**/test/{positive,negative}[0-9].{yaml,json}; do echo $sample; done
}

list_openapi_samples(){
  for sample in assets/queries/openAPI/**/test/{positive,negative}[0-9]*.{yaml,json}; do echo $sample; done
}

list_common_samples(){
  for sample in assets/queries/common/**/test/*[0-9].{tf,json,yaml,dockerfile}; do echo $sample; done
}

list_ansible_samples(){
  for sample in assets/queries/ansible/**/test/*.yaml; do echo $sample; done
}

list_docker_samples(){
  for sample in assets/queries/**/test/*.dockerfile; do echo $sample; done
}

list_terraform_samples(){
  for sample in assets/queries/terraform/**/test/*.tf; do echo $sample; done
}

run_unit_tests_and_filter_subtests(){
  go test ./... -v | grep -v TestQueriesContent/ | grep -v TestQueriesMetadata/ | grep -v TestQueries/ | grep PASS
}

println(){
  printf "|%-25s| %7d|\n" $@
}

print_header(){
  printf "|%-25s| %7s|\n" $@
}

print_sep(){
  printf '|'
  printf '-%.0s' {1..25}
  printf '|'
  printf '-%.0s' {1..8}
  printf '|'
  printf '\n'
}

echo "#################################"
echo "#          TEST METRICS         #"
echo "#################################"

OPENAPI_SAMPLES=$(list_openapi_samples | wc -l)
COMMON_SAMPLES=$(list_common_samples | wc -l)
CFN_SAMPLES=$(list_cfn_samples | wc -l)
ANSIBLE_SAMPLES=$(list_ansible_samples | wc -l)
DKR_SAMPLES=$(list_docker_samples | wc -l)
TF_SAMPLES=$(list_terraform_samples | wc -l)
TOTAL_SAMPLES=$((${TF_SAMPLES} + ${DKR_SAMPLES} + ${ANSIBLE_SAMPLES} + ${CFN_SAMPLES} + ${COMMON_SAMPLES} + ${OPENAPI_SAMPLES}))

echo "::group::Samples Metrics"
print_sep
print_header "Platform" "Samples"
print_sep
println "Ansible" "${ANSIBLE_SAMPLES}"
println "CloudFormation" "${CFN_SAMPLES}"
println "Common" "${COMMON_SAMPLES}"
println "Docker" "${DKR_SAMPLES}"
println "OpenAPI" "${OPENAPI_SAMPLES}"
println "Terraform" "${TF_SAMPLES}"
print_sep
println "Total" "${TOTAL_SAMPLES}"
print_sep
echo "::endgroup::"

echo "::set-output name=ansible::${ANSIBLE_SAMPLES}"
echo "::set-output name=cfn::${CFN_SAMPLES}"
echo "::set-output name=common::${COMMON_SAMPLES}"
echo "::set-output name=docker::${DKR_SAMPLES}"
echo "::set-output name=openapi::${OPENAPI_SAMPLES}"
echo "::set-output name=terraform::${TF_SAMPLES}"
echo
echo "Install Test Dependencies"
echo "::group::Install Test Dependencis"
go mod vendor
echo "::endgroup::"
echo
echo "Running Unit Tests..."
echo "::group::Unit Tests Metrics"
TOTAL_TESTS=$(run_unit_tests_and_filter_subtests | wc -l)
echo "Total unit tests: ${TOTAL_TESTS}"
echo "::endgroup::"
echo
echo "::set-output name=total_tests::${TOTAL_TESTS}"
