#!/usr/bin/env zsh

CFN_QUERIES_PREFIX=assets/queries/cloudFormation
OPENAPI_QUERIES_PREFIX=assets/queries/openAPI
ANSIBLE_QUERIES_PREFIX=assets/queries/ansible
DOCKERFILE_QUERIES_PREFIX=assets/queries/dockerfile
TERRAFORM_QUERIES_PREFIX=assets/queries/terraform

list_cfn_samples() {
  for sample in ${CFN_QUERIES_PREFIX}/**/test/{positive,negative}[0-9].{yaml,json}; do echo $sample; done
}

list_cfn_queries() {
  for sample in ${CFN_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_openapi_samples(){
  for sample in ${OPENAPI_QUERIES_PREFIX}/**/test/{positive,negative}[0-9]*.{yaml,json}; do echo $sample; done
}

list_openapi_queries(){
  for sample in ${OPENAPI_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_common_samples(){
  for sample in assets/queries/common/**/test/*[0-9].{tf,json,yaml,dockerfile}; do echo $sample; done
}

list_common_queries(){
  for sample in assets/queries/common/**/*.rego; do echo $sample; done
}

list_ansible_samples(){
  for sample in ${ANSIBLE_QUERIES_PREFIX}/**/test/*.yaml; do echo $sample; done
}

list_ansible_queries(){
  for sample in ${ANSIBLE_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_docker_samples(){
  for sample in ${DOCKERFILE_QUERIES_PREFIX}/**/test/*.dockerfile; do echo $sample; done
}

list_docker_queries(){
  for sample in ${DOCKERFILE_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_terraform_samples(){
  for sample in ${TERRAFORM_QUERIES_PREFIX}/**/test/*.tf; do echo $sample; done
}

list_terraform_queries(){
  for sample in ${TERRAFORM_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
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

ANSIBLE_SAMPLES=$(list_ansible_samples | wc -l)
CFN_SAMPLES=$(list_cfn_samples | wc -l)
COMMON_SAMPLES=$(list_common_samples | wc -l)
DKR_SAMPLES=$(list_docker_samples | wc -l)
OPENAPI_SAMPLES=$(list_openapi_samples | wc -l)
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

ANSIBLE_QUERIES=$(list_ansible_queries | wc -l)
CFN_QUERIES=$(list_cfn_queries | wc -l)
COMMON_QUERIES=$(list_common_queries | wc -l)
DKR_QUERIES=$(list_docker_queries | wc -l)
OPENAPI_QUERIES=$(list_openapi_queries | wc -l)
TF_QUERIES=$(list_terraform_queries | wc -l)
TOTAL_QUERIES=$((${TF_QUERIES} + ${DKR_QUERIES} + ${ANSIBLE_QUERIES} + ${CFN_QUERIES} + ${OPENAPI_QUERIES} + ${COMMON_QUERIES}))

echo "::group::Queries Metrics"
print_sep
print_header "Platform" "Rego"
print_sep
println "Ansible" "${ANSIBLE_QUERIES}"
println "CloudFormation" "${CFN_QUERIES}"
println "Common" "${COMMON_QUERIES}"
println "Docker" "${DKR_QUERIES}"
println "OpenAPI" "${OPENAPI_QUERIES}"
println "Terraform" "${TF_QUERIES}"
print_sep
println "Total" "${TOTAL_QUERIES}"
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
echo "::group::Install Test Dependencies"
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
