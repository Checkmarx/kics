#!/usr/bin/env zsh

CFN_QUERIES_PREFIX=assets/queries/cloudFormation
OPENAPI_QUERIES_PREFIX=assets/queries/openAPI
ANSIBLE_QUERIES_PREFIX=assets/queries/ansible
DOCKERFILE_QUERIES_PREFIX=assets/queries/dockerfile
KUBERNETES_QUERIES_PREFIX=assets/queries/k8s
COMMON_QUERIES_PREFIX=assets/queries/common
TERRAFORM_QUERIES_PREFIX=assets/queries/terraform

list_cfn_samples() {
  for sample in ${CFN_QUERIES_PREFIX}/**/test/{positive,negative}[0-9].{yaml,json}; do echo $sample; done
}

list_cfn_rego() {
  for sample in ${CFN_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_openapi_samples(){
  for sample in ${OPENAPI_QUERIES_PREFIX}/**/test/{positive,negative}[0-9]*.{yaml,json}; do echo $sample; done
}

list_openapi_rego(){
  for sample in ${OPENAPI_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_common_samples(){
  for sample in ${COMMON_QUERIES_PREFIX}/**/test/*[0-9].{tf,json,yaml,dockerfile}; do echo $sample; done
}

list_common_rego(){
  for sample in ${COMMON_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_ansible_samples(){
  for sample in ${ANSIBLE_QUERIES_PREFIX}/**/test/*.yaml; do echo $sample; done
}

list_ansible_rego(){
  for sample in ${ANSIBLE_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_docker_samples(){
  for sample in ${DOCKERFILE_QUERIES_PREFIX}/**/test/*.dockerfile; do echo $sample; done
}

list_docker_rego(){
  for sample in ${DOCKERFILE_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

list_terraform_samples(){
  for sample in ${TERRAFORM_QUERIES_PREFIX}/**/test/*.tf; do echo $sample; done
}

list_terraform_rego(){
  for sample in ${TERRAFORM_QUERIES_PREFIX}/**/*.rego; do echo $sample; done
}

count_queries(){
  SUM=0
  for sample in $1/$2/**/metadata.json; do
    SUM=$(($SUM + $(jq 'if .aggregation then .aggregation else 1 end' $sample)));
  done
  echo ${SUM}
}

count_queries_flat(){
  SUM=0
  for sample in $1/**/metadata.json; do
    SUM=$(($SUM + $(jq 'if .aggregation then .aggregation else 1 end' $sample)));
  done
  echo ${SUM}
}

count_terraform_aws_queries(){
  count_queries ${TERRAFORM_QUERIES_PREFIX} 'aws'
}

count_terraform_gcp_queries(){
  count_queries ${TERRAFORM_QUERIES_PREFIX} 'gcp'
}

count_terraform_azure_queries(){
  count_queries ${TERRAFORM_QUERIES_PREFIX} 'azure'
}

count_dockerfile_queries(){
  count_queries_flat ${DOCKERFILE_QUERIES_PREFIX}
}

count_kubernetes_queries(){
  count_queries_flat ${KUBERNETES_QUERIES_PREFIX}
}

count_openapi_queries(){
  count_queries_flat ${OPENAPI_QUERIES_PREFIX}
}

count_common_queries(){
  count_queries_flat ${COMMON_QUERIES_PREFIX}
}

count_cloudformation_queries(){
  count_queries_flat ${CFN_QUERIES_PREFIX}
}

count_ansible_aws_queries(){
  count_queries ${ANSIBLE_QUERIES_PREFIX} 'aws'
}

count_ansible_gcp_queries(){
  count_queries ${ANSIBLE_QUERIES_PREFIX} 'gcp'
}

count_ansible_azure_queries(){
  count_queries ${ANSIBLE_QUERIES_PREFIX} 'azure'
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

COMMON=$(count_common_queries)
DOCKERFILE=$(count_dockerfile_queries)
KUBERNETES=$(count_kubernetes_queries)
OPENAPI=$(count_openapi_queries)
CFN=$(count_cloudformation_queries)
ANSIBLE_GCP=$(count_ansible_gcp_queries)
ANSIBLE_AWS=$(count_ansible_aws_queries)
ANSIBLE_AZR=$(count_ansible_azure_queries)
TF_AWS=$(count_terraform_aws_queries)
TF_GCP=$(count_terraform_gcp_queries)
TF_AZR=$(count_terraform_azure_queries)
TOTAL_QUERIES=$((${DOCKERFILE} + ${KUBERNETES} + ${OPENAPI} + ${COMMON} + ${CFN} + ${ANSIBLE_GCP} + ${ANSIBLE_AWS} + ${ANSIBLE_AZR} + ${TF_GCP} + ${TF_AWS} + ${TF_AZR}))

echo "#######################################"
echo "#          QUERIES METRICS            #"
echo "#######################################"

echo "::group::Queries Metrics"
print_sep
print_header "Platform" "Samples"
print_sep
println "Ansible AWS" "${ANSIBLE_AWS}"
println "Ansible GCP" "${ANSIBLE_GCP}"
println "Ansible AZR" "${ANSIBLE_AZR}"
print_sep
println "Ansible" "$(($ANSIBLE_AWS + $ANSIBLE_GCP + $ANSIBLE_AZR))"
print_sep
println "CloudFormation" "${CFN}"
println "Common" "${COMMON}"
println "Docker" "${DOCKERFILE}"
println "Kubernetes" "${KUBERNETES}"
println "OpenAPI" "${OPENAPI}"
println "Terraform AWS" "${TF_AWS}"
println "Terraform GCP" "${TF_GCP}"
println "Terraform AZR" "${TF_AZR}"
print_sep
println "Terraform" "$(($TF_AZR + $TF_GCP + $TF_AWS))"
print_sep
echo "::endgroup::"

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

ANSIBLE_REGO=$(list_ansible_rego | wc -l)
CFN_REGO=$(list_cfn_rego | wc -l)
COMMON_REGO=$(list_common_rego | wc -l)
DKR_REGO=$(list_docker_rego | wc -l)
OPENAPI_REGO=$(list_openapi_rego | wc -l)
TF_REGO=$(list_terraform_rego | wc -l)
TOTAL_REGO=$((${TF_REGO} + ${DKR_REGO} + ${ANSIBLE_REGO} + ${CFN_REGO} + ${OPENAPI_REGO} + ${COMMON_REGO}))

echo "::group::Rego Metrics"
print_sep
print_header "Platform" "Rego"
print_sep
println "Ansible" "${ANSIBLE_REGO}"
println "CloudFormation" "${CFN_REGO}"
println "Common" "${COMMON_REGO}"
println "Docker" "${DKR_REGO}"
println "OpenAPI" "${OPENAPI_REGO}"
println "Terraform" "${TF_REGO}"
print_sep
println "Total" "${TOTAL_REGO}"
print_sep
echo "::endgroup::"

echo "::set-output name=ansible::${ANSIBLE_SAMPLES}"
echo "::set-output name=cfn::${CFN_SAMPLES}"
echo "::set-output name=common::${COMMON_SAMPLES}"
echo "::set-output name=docker::${DKR_SAMPLES}"
echo "::set-output name=openapi::${OPENAPI_SAMPLES}"
echo "::set-output name=terraform::${TF_SAMPLES}"
echo

echo "#######################################"
echo "#             TEST METRICS            #"
echo "#######################################"

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

echo "#######################################"
echo "#            LINES OF CODE            #"
echo "#######################################"

echo "::group::Lines of code"
cloc --exclude-dir=vendor .
echo "::endgroup::"
