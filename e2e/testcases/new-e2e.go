package testcases

import (
	"regexp"
)

var stringTest = "should run a scan for all platforms: "

// E2E-CLI-094 - KICS scan all platforms
// should run a scan for all provided paths/files
func init() { 
	testSample01 := TestCase{
		Name: stringTest + "ansible (aws) [E2E-CLI-094_1]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/ansible/aws/alb_listening_on_http/test/positive.yaml,/path/assets/queries/ansible/aws/iam_access_key_is_exposed/test/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: ansible`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample02 := TestCase{
		Name: stringTest + "ansible (azure) [E2E-CLI-094_2]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/ansible/azure/log_retention_is_not_set/test/positive.yaml,/path/assets/queries/ansible/azure/public_storage_account/test/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: ansible`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample03 := TestCase{
		Name: stringTest + "azureResourceManager [E2E-CLI-094_3]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/azureResourceManager/aks_logging_azure_monitoring_disabled/test/positive4.json,/path/assets/queries/azureResourceManager/key_vault_not_recoverable/test/positive3.json"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: azureresourcemanager`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample04 := TestCase{
		Name: stringTest + "buildah [E2E-CLI-094_4]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/buildah/run_using_apt/test/positive.sh"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: buildah`, outputText)
			return match
		},
		WantStatus: []int{30},
	}

	testSample05 := TestCase{
		Name: stringTest + "cicd (github) [E2E-CLI-094_5]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/cicd/github/run_block_injection/test/positive7.yaml,/path/assets/queries/cicd/github/script_block_injection/test/positive5.yaml,/path/assets/queries/cicd/github/unpinned_actions_full_length_commit_sha/test/positive1.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: cicd`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample06 := TestCase{
		Name: stringTest + "cloudFormation (aws) [E2E-CLI-094_6]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/cloudFormation/aws/alb_listening_on_http/test/positive1.yaml,/path/assets/queries/cloudFormation/aws/api_gateway_deployment_without_access_log_setting/test/positive1.yaml,/path/assets/queries/cloudFormation/aws/api_gateway_deployment_without_access_log_setting/test/positive5.json,/path/assets/queries/cloudFormation/aws/ecs_task_definition_invalid_cpu_or_memory/test/positive1.yaml,/path/assets/queries/cloudFormation/aws/iam_access_analyzer_not_enabled/test/positive2.json,/path/assets/queries/cloudFormation/aws/rds_storage_encryption_disabled/test/positive3.json,/path/assets/queries/cloudFormation/aws/s3_bucket_cloudtrail_logging_disabled/test/positive1.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: cloudformation`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample07 := TestCase{
		Name: stringTest + "cloudFormation (aws_bom) [E2E-CLI-094_7]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/cloudFormation/aws_bom/cassandra/test/positive1.yaml,/path/assets/queries/cloudFormation/aws_bom/dynamo/test/positive2.yaml,/path/assets/queries/cloudFormation/aws_bom/elasticache/test/positive2.json"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: cloudformation`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample08 := TestCase{
		Name: stringTest + "cloudFormation (aws_sam) [E2E-CLI-094_8]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/cloudFormation/aws_sam/serverless_api_access_logging_setting_undefined/test/positive1.yaml,/path/assets/queries/cloudFormation/aws_sam/serverless_function_environment_variables_not_encrypted/test/positive1.yaml,/path/assets/queries/cloudFormation/aws_sam/serverless_function_without_unique_iam_role/test/positive2.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: cloudformation`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	//verificar depois melhorp or causa do output
	testSample09 := TestCase{
		Name: stringTest + "common [E2E-CLI-094_9]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/common/passwords_and_secrets/test/positive1.yaml,/path/assets/queries/common/passwords_and_secrets/test/positive5.tf,/path/assets/queries/common/passwords_and_secrets/test/positive6.dockerfile,/path/assets/queries/common/passwords_and_secrets/test/positive8.json,/path/assets/queries/common/passwords_and_secrets/test/positive11.yaml,/path/assets/queries/common/passwords_and_secrets/test/positive21.tf,/path/assets/queries/common/passwords_and_secrets/test/positive25.dockerfile,/path/assets/queries/common/passwords_and_secrets/test/positive38.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: (terraform|dockerfile|kubernetes|openapi|cloudformation)`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample10 := TestCase{
		Name: stringTest + "crossplane (aws) [E2E-CLI-094_10]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/crossplane/aws/cloudfront_without_waf/test/positive.yaml,/path/assets/queries/crossplane/aws/cloudwatch_without_retention_period_specified/test/positive.yaml,/path/assets/queries/crossplane/aws/efs_not_encrypted/test/positive2.yaml,/path/assets/queries/crossplane/aws/rds_db_instance_publicly_accessible/test/positive2.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: crossplane`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample11 := TestCase{
		Name: stringTest + "crossplane (azure) [E2E-CLI-094_11]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/crossplane/azure/aks_rbac_disabled/test/positive.yaml,/path/assets/queries/crossplane/azure/redis_cache_allows_non_ssl_connections/test/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: crossplane`, outputText)
			return match
		},
		WantStatus: []int{40},
	}

	testSample12 := TestCase{
		Name: stringTest + "crossplane (gcp) [E2E-CLI-094_12]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/crossplane/gcp/cloud_storage_bucket_logging_not_enabled/test/positive.yaml,/path/assets/queries/crossplane/gcp/google_container_node_pool_auto_repair_disabled/test/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: crossplane`, outputText)
			return match
		},
		WantStatus: []int{40},
	}

	testSample13 := TestCase{
		Name: stringTest + "dockercompose [E2E-CLI-094_13]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/dockerCompose/cpus_not_limited/test/positive5.yaml,/path/assets/queries/dockerCompose/memory_not_limited/test/positive5.yaml,/path/assets/queries/dockerCompose/security_opt_not_set/test/positive1.yaml,/path/assets/queries/dockerCompose/shared_volumes_between_containers/test/positive2.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: dockercompose`, outputText)
			return match
		},
		WantStatus: []int{40},
	}

	testSample14 := TestCase{
		Name: stringTest + "dockerfile [E2E-CLI-094_14]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile,/path/assets/queries/dockerfile/apt_get_install_pin_version_not_defined/test/positive2.dockerfile,/path/assets/queries/dockerfile/healthcheck_instruction_missing/test/positive2.dockerfile,/path/assets/queries/dockerfile/image_version_not_explicit/test/positive2.dockerfile,/path/assets/queries/dockerfile/missing_user_instruction/test/positive2.dockerfile,/path/assets/queries/dockerfile/npm_install_without_pinned_version/test/positive1.dockerfile,/path/assets/queries/dockerfile/run_using_apt/test/positive.dockerfile,/path/assets/queries/dockerfile/unpinned_package_version_in_pip_install/test/positive1.dockerfile,/path/assets/queries/dockerfile/using_platform_with_from/test/positive.dockerfile"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: dockerfile`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample15 := TestCase{
		Name: stringTest + "googleDeploymentManager (gcp) [E2E-CLI-094_15]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/googleDeploymentManager/gcp/google_storage_bucket_level_access_disabled/test/positive1.yaml,/path/assets/queries/googleDeploymentManager/gcp/ip_aliasing_disabled/test/positive3.yaml,/path/assets/queries/googleDeploymentManager/gcp/private_cluster_disabled/test/positive2.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: googledeploymentmanager`, outputText)
			return match
		},
		WantStatus: []int{60},
	}

	testSample16 := TestCase{
		Name: stringTest + "googleDeploymentManager (gcp_bom) [E2E-CLI-094_16]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/googleDeploymentManager/gcp_bom/pd/test/positive.yaml,/path/assets/queries/googleDeploymentManager/gcp_bom/pst/test/positive.yaml,/path/assets/queries/googleDeploymentManager/gcp_bom/sb/test/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: googledeploymentmanager`, outputText)
			return match
		},
		WantStatus: []int{60},
	}

	testSample17 := TestCase{
		Name: stringTest + "grpc [E2E-CLI-094_17]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/grpc/enum_name_not_camel_case/test/positive.proto"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: grpc`, outputText)
			return match
		},
		WantStatus: []int{20},
	}

	testSample18 := TestCase{
		Name: stringTest + "grpc [E2E-CLI-094_18]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/k8s/client_certificate_authentication_not_setup_properly/test/positive6.yaml,/path/assets/queries/k8s/cpu_limits_not_set/test/positive.yaml,/path/assets/queries/k8s/image_without_digest/test/positive.yaml,/path/assets/queries/k8s/memory_limits_not_defined/test/positive2.yaml,/path/assets/queries/k8s/memory_requests_not_defined/test/positive2.yaml,/path/assets/queries/k8s/not_limited_capabilities_for_pod_security_policy/test/positive.yaml,/path/assets/queries/k8s/service_account_allows_access_secrets/test/positive.yaml,/path/assets/queries/k8s/volume_mount_with_os_directory_write_permissions/test/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: kubernetes`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample19 := TestCase{
		Name: stringTest + "grpc [E2E-CLI-094_19]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/knative/serving_revision_spec_without_timeout_settings/test/positive1.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: knative`, outputText)
			return match
		},
		WantStatus: []int{40},
	}
	
	testSample20 := TestCase{
		Name: stringTest + "openapi (2.0) [E2E-CLI-094_20]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/openAPI/2.0/invalid_oauth2_token_url/test/positive1.yaml,/path/assets/queries/openAPI/2.0/invalid_oauth2_token_url/test/positive2.json,/path/assets/queries/openAPI/2.0/object_without_required_property/test/positive1.json,/path/assets/queries/openAPI/2.0/object_without_required_property/test/positive2.yaml,/path/assets/queries/openAPI/2.0/schemes_uses_http copy/test/positive1.json,/path/assets/queries/openAPI/2.0/schemes_uses_http copy/test/positive2.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: openapi`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample21 := TestCase{
		Name: stringTest + "openapi (3.0) [E2E-CLI-094_21]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/openAPI/3.0/api_key_exposed_in_global_security_scheme/test/positive1.json,/path/assets/queries/openAPI/3.0/api_key_exposed_in_global_security_scheme/test/positive2.yaml,/path/assets/queries/openAPI/3.0/global_server_uses_http/test/positive1.json,/path/assets/queries/openAPI/3.0/global_server_uses_http/test/positive2.yaml,/path/assets/queries/openAPI/3.0/invalid_oauth_authorization_url/test/positive1.json,/path/assets/queries/openAPI/3.0/invalid_oauth_authorization_url/test/positive3.yaml,/path/assets/queries/openAPI/3.0/path_server_uses_http/test/positive1.json,/path/assets/queries/openAPI/3.0/path_server_uses_http/test/positive2.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: openapi`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	testSample22 := TestCase{
		Name: stringTest + "openapi (general) [E2E-CLI-094_22]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/assets/queries/openAPI/general/array_without_maximum_number_items/test/positive6.yaml,/path/assets/queries/openAPI/general/array_without_maximum_number_items/test/positive5.json,/path/assets/queries/openAPI/general/json_object_schema_without_properties/test/positive6.yaml,/path/assets/queries/openAPI/general/json_object_schema_without_properties/test/positive5.json,/path/assets/queries/openAPI/general/maximum_length_undefined/test/positive9.json,/path/assets/queries/openAPI/general/maximum_length_undefined/test/positive6.yaml,/path/assets/queries/openAPI/general/numeric_schema_without_minimum/test/positive6.yaml,/path/assets/queries/openAPI/general/numeric_schema_without_minimum/test/positive5.json,/path/assets/queries/openAPI/general/pattern_undefined/test/positive6.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: openapi`, outputText)
			return match
		},
		WantStatus: []int{50},
	}



	Tests = append(Tests, testSample01, testSample02, testSample03, testSample04, testSample05, testSample06, testSample07, testSample08, testSample09, testSample10, testSample11, testSample12, testSample13, testSample14, testSample15, testSample16, testSample17, testSample18, testSample19, testSample20, testSample21, testSample22)
}
