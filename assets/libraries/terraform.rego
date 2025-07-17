package generic.terraform

import data.generic.common as common_lib

check_cidr(rule) {
	rule.cidr_blocks[_] == "0.0.0.0/0"
} else {
	rule.cidr_block == "0.0.0.0/0"
} else {
	rule.ipv6_cidr_blocks[_] == "::/0"
} else {
	rule.ipv6_cidr_blocks == "::/0"
} else {
	rule.ipv6_cidr_blocks[_] == "0000:0000:0000:0000:0000:0000:0000:0000/0"
} else {
	rule.ipv6_cidr_blocks == "0000:0000:0000:0000:0000:0000:0000:0000/0"
} else {
	rule.ipv6_cidr_blocks[_] == "0:0:0:0:0:0:0:0/0"
} else {
	rule.ipv6_cidr_blocks == "0:0:0:0:0:0:0:0/0"
}


# Checks if a TCP port is open in a rule
portOpenToInternet(rule, port) {
	check_cidr(rule)
	rule.protocol == "tcp"
	containsPort(rule, port)
}

portOpenToInternet(rules, port) {
	rule := rules[_]
	check_cidr(rule)
	rule.protocol == "tcp"
	containsPort(rule, port)
}

# Checks if a port is included in a rule
containsPort(rule, port) {
	rule.from_port <= port
	rule.to_port >= port
} else {
	rule.from_port == 0
	rule.to_port == 0
} else {
	regex.match(sprintf("(^|\\s|,)%d(-|,|$|\\s)", [port]), rule.destination_port_range)
} else {
	ports := split(rule.destination_port_range, ",")
	sublist := split(ports[var], "-")
	to_number(trim(sublist[0], " ")) <= port
	to_number(trim(sublist[1], " ")) >= port
} else {
	ports := split(rule.port_range, ",")
	sublist := split(ports[var], "/")
	to_number(trim(sublist[0], " ")) <= port
	to_number(trim(sublist[1], " ")) >= port
}

# Gets the list of protocols
getProtocolList("-1") = protocols {
	protocols := ["TCP", "UDP", "ICMP"]
}

getProtocolList("*") = protocols {
	protocols := ["TCP", "UDP", "ICMP"]
}

getProtocolList(protocol) = protocols {
	upper(protocol) == "TCP"
	protocols := ["TCP"]
}

getProtocolList(protocol) = protocols {
	upper(protocol) == "UDP"
	protocols := ["UDP"]
}

# Checks if any principal are allowed in a policy
anyPrincipal(statement) {
    some p
    p = get_principal(statement)
	contains(p, "*")
}

anyPrincipal(statement) {
    some p
    p = get_principal(statement)
	contains(p[_], "*")
}

anyPrincipal(statement) {
	some p
	p = get_principal_aws(statement)
	is_string(p)
	contains(p, "*")
}

anyPrincipal(statement) {
    some arr
    arr = get_principal_aws(statement)
    is_array(arr)
    some i
    contains(arr[i], "*")
}

get_principal(statement) = p {
	statement.Principal != null
	p = statement.Principal
} else = p {
	statement.Principals != null
	p = statement.Principals
}

get_principal_aws(statement) = p {
	some principal
	principal = get_principal(statement)
	principal.AWS != null
	p := principal.AWS
}

getSpecInfo(resource) = specInfo { # this one can be also used for the result
	spec := resource.spec.job_template.spec.template.spec
	specInfo := {"spec": spec, "path": "spec.job_template.spec.template.spec"}
} else = specInfo {
	spec := resource.spec.template.spec
	specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
	spec := resource.spec
	specInfo := {"spec": spec, "path": "spec"}
}

check_resource_tags(p) {
	resource = {
		"aws_acm_certificate": "",
		"aws_acmpca_certificate_authority": "",
		"aws_api_gateway_api_key": "",
		"aws_api_gateway_client_certificate": "",
		"aws_api_gateway_domain_name": "",
		"aws_api_gateway_rest_api": "",
		"aws_api_gateway_stage": "",
		"aws_api_gateway_usage_plan": "",
		"aws_api_gateway_vpc_link": "",
		"aws_apigatewayv2_api": "",
		"aws_apigatewayv2_domain_name": "",
		"aws_apigatewayv2_stage": "",
		"aws_apigatewayv2_vpc_link": "",
		"aws_accessanalyzer_analyzer": "",
		"aws_appmesh_gateway_route": "",
		"aws_appmesh_mesh": "",
		"aws_appmesh_route": "",
		"aws_appmesh_virtual_gateway": "",
		"aws_appmesh_virtual_node": "",
		"aws_appmesh_virtual_router": "",
		"aws_appmesh_virtual_service": "",
		"aws_appsync_graphql_api": "",
		"aws_athena_workgroup": "",
		"aws_autoscaling_group": "",
		"aws_backup_plan": "",
		"aws_backup_vault": "",
		"aws_batch_compute_environment": "",
		"aws_batch_job_definition": "",
		"aws_batch_job_queue": "",
		"aws_cloud9_environment_ec2": "",
		"aws_cloudformation_stack": "",
		"aws_cloudformation_stack_set": "",
		"aws_cloudfront_distribution": "",
		"aws_cloudhsm_v2_cluster": "",
		"aws_cloudtrail": "",
		"aws_cloudwatch_composite_alarm": "",
		"aws_cloudwatch_log_group": "",
		"aws_cloudwatch_metric_alarm": "",
		"aws_codeartifact_domain": "",
		"aws_codeartifact_repository": "",
		"aws_codebuild_project": "",
		"aws_codebuild_report_group": "",
		"aws_codecommit_repository": "",
		"aws_codedeploy_app": "",
		"aws_codedeploy_deployment_group": "",
		"aws_codepipeline_webhook": "",
		"aws_codestarconnections_connection": "",
		"aws_codestarnotifications_notification_rule": "",
		"aws_cognito_identity_pool": "",
		"aws_cognito_user_pool": "",
		"aws_config_aggregate_authorization": "",
		"aws_config_config_rule": "",
		"aws_config_configuration_aggregator": "",
		"aws_dlm_lifecycle_policy": "",
		"aws_datapipeline_pipeline": "",
		"aws_datasync_agent": "",
		"aws_datasync_location_efs": "",
		"aws_datasync_location_fsx_windows_file_system": "",
		"aws_datasync_location_nfs": "",
		"aws_datasync_location_s3": "",
		"aws_datasync_location_smb": "",
		"aws_datasync_task": "",
		"aws_dms_certificate": "",
		"aws_dms_endpoint": "",
		"aws_dms_event_subscription": "",
		"aws_dms_replication_instance": "",
		"aws_dms_replication_subnet_group": "",
		"aws_dms_replication_task": "",
		"aws_dx_connection": "",
		"aws_dx_hosted_public_virtual_interface": "",
		"aws_dx_hosted_private_virtual_interface_accepter": "",
		"aws_dx_hosted_transit_virtual_interface_accepter": "",
		"aws_dx_lag": "",
		"aws_dx_private_virtual_interface": "",
		"aws_dx_public_virtual_interface": "",
		"aws_dx_transit_virtual_interface": "",
		"aws_directory_service_directory": "",
		"aws_docdb_cluster": "",
		"aws_docdb_cluster_instance": "",
		"aws_docdb_cluster_parameter_group": "",
		"aws_docdb_subnet_group": "",
		"aws_dynamodb_table": "",
		"aws_dax_cluster": "",
		"aws_ami": "",
		"aws_ami_copy": "",
		"aws_ami_from_instance": "",
		"aws_ebs_snapshot": "",
		"aws_ebs_snapshot_copy": "",
		"aws_ebs_volume": "",
		"aws_ec2_capacity_reservation": "",
		"aws_ec2_carrier_gateway": "",
		"aws_ec2_client_vpn_endpoint": "",
		"aws_ec2_fleet": "",
		"aws_ec2_local_gateway_route_table_vpc_association": "",
		"aws_ec2_traffic_mirror_filter": "",
		"aws_ec2_traffic_mirror_session": "",
		"aws_ec2_traffic_mirror_target": "",
		"aws_ec2_transit_gateway": "",
		"aws_ec2_transit_gateway_peering_attachment": "",
		"aws_ec2_transit_gateway_peering_attachment_accepter": "",
		"aws_ec2_transit_gateway_route_table": "",
		"aws_ec2_transit_gateway_vpc_attachment": "",
		"aws_ec2_transit_gateway_vpc_attachment_accepter": "",
		"aws_eip": "",
		"aws_instance": "",
		"aws_key_pair": "",
		"aws_launch_template": "",
		"aws_placement_group": "",
		"aws_spot_fleet_request": "",
		"aws_spot_instance_request": "",
		"aws_ecr_repository": "",
		"aws_ecs_capacity_provider": "",
		"aws_ecs_cluster": "",
		"aws_ecs_service": "",
		"aws_ecs_task_definition": "",
		"aws_efs_access_point": "",
		"aws_efs_file_system": "",
		"aws_eks_addon": "",
		"aws_eks_cluster": "",
		"aws_eks_fargate_profile": "",
		"aws_eks_node_group": "",
		"aws_elasticache_cluster": "",
		"aws_elasticache_replication_group": "",
		"aws_elasticache_subnet_group": "",
		"aws_elastic_beanstalk_application": "",
		"aws_elastic_beanstalk_application_version": "",
		"aws_elastic_beanstalk_environment": "",
		"aws_elb": "",
		"aws_lb": "",
		"aws_lb_target_group": "",
		"aws_emr_cluster": "",
		"aws_elasticsearch_domain": "",
		"aws_cloudwatch_event_bus": "",
		"aws_cloudwatch_event_rule": "",
		"aws_fsx_lustre_file_system": "",
		"aws_fsx_windows_file_system": "",
		"aws_gamelift_alias": "",
		"aws_gamelift_build": "",
		"aws_gamelift_fleet": "",
		"aws_gamelift_game_session_queue": "",
		"aws_glacier_vault": "",
		"aws_globalaccelerator_accelerator": "",
		"aws_glue_crawler": "",
		"aws_glue_dev_endpoint": "",
		"aws_glue_job": "",
		"aws_glue_ml_transform": "",
		"aws_glue_registry": "",
		"aws_glue_schema": "",
		"aws_glue_trigger": "",
		"aws_glue_workflow": "",
		"aws_guardduty_detector": "",
		"aws_guardduty_filter": "",
		"aws_guardduty_ipset": "",
		"aws_guardduty_threatintelset": "",
		"aws_iam_instance_profile": "",
		"aws_iam_openid_connect_provider": "",
		"aws_iam_policy": "",
		"aws_iam_role": "",
		"aws_iam_saml_provider": "",
		"aws_iam_server_certificate": "",
		"aws_iam_user": "",
		"aws_imagebuilder_component": "",
		"aws_imagebuilder_distribution_configuration": "",
		"aws_imagebuilder_image": "",
		"aws_imagebuilder_image_pipeline": "",
		"aws_imagebuilder_image_recipe": "",
		"aws_imagebuilder_infrastructure_configuration": "",
		"aws_inspector_assessment_template": "",
		"aws_iot_topic_rule": "",
		"aws_kms_external_key": "",
		"aws_kms_key": "",
		"aws_kinesis_stream": "",
		"aws_kinesis_analytics_application": "",
		"aws_kinesisanalyticsv2_application": "",
		"aws_kinesis_firehose_delivery_stream": "",
		"aws_kinesis_video_stream": "",
		"aws_lambda_function": "",
		"aws_licensemanager_license_configuration": "",
		"aws_lightsail_instance": "",
		"aws_mq_broker": "",
		"aws_mq_configuration": "",
		"aws_msk_cluster": "",
		"aws_mwaa_environment": "",
		"aws_media_convert_queue": "",
		"aws_media_package_channel": "",
		"aws_media_store_container": "",
		"aws_neptune_cluster": "",
		"aws_neptune_cluster_instance": "",
		"aws_neptune_cluster_parameter_group": "",
		"aws_neptune_event_subscription": "",
		"aws_neptune_parameter_group": "",
		"aws_neptune_subnet_group": "",
		"aws_networkfirewall_firewall": "",
		"aws_networkfirewall_firewall_policy": "",
		"aws_networkfirewall_rule_group": "",
		"aws_opsworks_custom_layer": "",
		"aws_opsworks_ganglia_layer": "",
		"aws_opsworks_haproxy_layer": "",
		"aws_opsworks_java_app_layer": "",
		"aws_opsworks_memcached_layer": "",
		"aws_opsworks_mysql_layer": "",
		"aws_opsworks_nodejs_app_layer": "",
		"aws_opsworks_php_app_layer": "",
		"aws_opsworks_rails_app_layer": "",
		"aws_opsworks_stack": "",
		"aws_opsworks_static_web_layer": "",
		"aws_organizations_account": "",
		"aws_organizations_organizational_unit": "",
		"aws_organizations_policy": "",
		"aws_pinpoint_app": "",
		"aws_qldb_ledger": "",
		"aws_ram_resource_share": "",
		"aws_db_cluster_snapshot": "",
		"aws_db_event_subscription": "",
		"aws_db_instance": "",
		"aws_db_option_group": "",
		"aws_db_parameter_group": "",
		"aws_db_proxy": "",
		"aws_db_proxy_endpoint": "",
		"aws_db_security_group": "",
		"aws_db_subnet_group": "",
		"aws_rds_cluster": "",
		"aws_rds_cluster_endpoint": "",
		"aws_rds_cluster_instance": "",
		"aws_rds_cluster_parameter_group": "",
		"aws_redshift_cluster": "",
		"aws_redshift_event_subscription": "",
		"aws_redshift_parameter_group": "",
		"aws_redshift_snapshot_copy_grant": "",
		"aws_redshift_snapshot_schedule": "",
		"aws_redshift_subnet_group": "",
		"aws_resourcegroups_group": "",
		"aws_route53_health_check": "",
		"aws_route53_zone": "",
		"aws_route53_resolver_endpoint": "",
		"aws_route53_resolver_firewall_domain_list": "",
		"aws_route53_resolver_firewall_rule_group": "",
		"aws_route53_resolver_firewall_rule_group_association": "",
		"aws_route53_resolver_query_log_config": "",
		"aws_route53_resolver_rule": "",
		"aws_s3_bucket": "",
		"aws_s3_bucket_object": "",
		"aws_s3_object_copy": "",
		"aws_s3control_bucket": "",
		"aws_sns_topic": "",
		"aws_sqs_queue": "",
		"aws_ssm_activation": "",
		"aws_ssm_document": "",
		"aws_ssm_maintenance_window": "",
		"aws_ssm_parameter": "",
		"aws_ssm_patch_baseline": "",
		"aws_ssoadmin_permission_set": "",
		"aws_swf_domain": "",
		"aws_sagemaker_app": "",
		"aws_sagemaker_domain": "",
		"aws_sagemaker_endpoint": "",
		"aws_sagemaker_endpoint_configuration": "",
		"aws_sagemaker_feature_group": "",
		"aws_sagemaker_image": "",
		"aws_sagemaker_model": "",
		"aws_sagemaker_model_package_group": "",
		"aws_sagemaker_notebook_instance": "",
		"aws_sagemaker_user_profile": "",
		"aws_secretsmanager_secret": "",
		"aws_serverlessapplicationrepository_cloudformation_stack": "",
		"aws_servicecatalog_portfolio": "",
		"aws_service_discovery_http_namespace": "",
		"aws_service_discovery_private_dns_namespace": "",
		"aws_service_discovery_public_dns_namespace": "",
		"aws_service_discovery_service": "",
		"aws_shield_protection": "",
		"aws_signer_signing_profile": "",
		"aws_sfn_activity": "",
		"aws_sfn_state_machine": "",
		"aws_storagegateway_cached_iscsi_volume": "",
		"aws_storagegateway_gateway": "",
		"aws_storagegateway_nfs_file_share": "",
		"aws_storagegateway_smb_file_share": "",
		"aws_storagegateway_stored_iscsi_volume": "",
		"aws_storagegateway_tape_pool": "",
		"aws_synthetics_canary": "",
		"aws_transfer_server": "",
		"aws_transfer_user": "",
		"aws_customer_gateway": "",
		"aws_default_network_acl": "",
		"aws_default_route_table": "",
		"aws_default_security_group": "",
		"aws_default_subnet": "",
		"aws_ec2_managed_prefix_list": "",
		"aws_egress_only_internet_gateway": "",
		"aws_flow_log": "",
		"aws_internet_gateway": "",
		"aws_nat_gateway": "",
		"aws_network_acl": "",
		"aws_network_interface": "",
		"aws_route_table": "",
		"aws_security_group": "",
		"aws_subnet": "",
		"aws_vpc": "",
		"aws_vpc_dhcp_options": "",
		"aws_vpc_endpoint": "",
		"aws_vpc_endpoint_service": "",
		"aws_vpc_peering_connection": "",
		"aws_vpc_peering_connection_accepter": "",
		"aws_vpn_connection": "",
		"aws_vpn_gateway": "",
		"aws_waf_rate_based_rule": "",
		"aws_waf_rule": "",
		"aws_waf_rule_group": "",
		"aws_waf_web_acl": "",
		"aws_wafregional_rate_based_rule": "",
		"aws_wafregional_rule": "",
		"aws_wafregional_rule_group": "",
		"aws_wafregional_web_acl": "",
		"aws_wafv2_ip_set": "",
		"aws_wafv2_regex_pattern_set": "",
		"aws_wafv2_rule_group": "",
		"aws_wafv2_web_acl": "",
		"aws_workspaces_directory": "",
		"aws_workspaces_ip_group": "",
		"aws_workspaces_workspace": "",
		"aws_xray_group": "",
		"aws_xray_sampling_rule": "",
	}

	resource[p]
}

empty_array(arr) {
	arr == []
} else {
	arr == null
} else {
	false
}

uses_aws_managed_key(key, awsManagedKey) {
	key == awsManagedKey
} else {
	keyName := split(key, ".")[2]
	kms := input.document[z].data.aws_kms_key[keyName]
	kms.key_id == awsManagedKey
}

getStatement(policy) = st {
	is_array(policy.Statement)
	st = policy.Statement
} else = st {
	st := [policy.Statement]
}

is_publicly_accessible(policy) {
	statements := getStatement(policy)
	statement:= statements[_]
	statement.Effect == "Allow"
	anyPrincipal(statement)
}

get_accessibility(resource, name, resourcePolicyName, resourceTarget) = info {
	policy := common_lib.json_unmarshal(resource.policy)
	is_publicly_accessible(policy)
	info = {"accessibility": "public", "policy": policy}
} else = info {
	policy := common_lib.json_unmarshal(resource.policy)
	not is_publicly_accessible(policy)
	info = {"accessibility": "hasPolicy", "policy": policy}
} else = info {
	not common_lib.valid_key(resource, "policy")

	resourcePolicy := input.document[_].resource[resourcePolicyName][_]
	split(resourcePolicy[resourceTarget], ".")[1] == name

	policy := common_lib.json_unmarshal(resourcePolicy.policy)
	is_publicly_accessible(policy)
	info = {"accessibility": "public", "policy": policy}
} else = info {
	not common_lib.valid_key(resource, "policy")

	resourcePolicy := input.document[_].resource[resourcePolicyName][_]
	split(resourcePolicy[resourceTarget], ".")[1] == name

	policy := common_lib.json_unmarshal(resourcePolicy.policy)
	not is_publicly_accessible(policy)
	info = {"accessibility": "hasPolicy", "policy": policy}
} else = info {
	info = {"accessibility": "unknown", "policy": ""}
}

is_default_password(password) = output {
   contains(password, data.common_lib.default_passwords[_])
   output = true
} else = output {
	# repetition of the same number more than three times
	regex.match(`(0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,})`, password) == true
	output = true
} else = output {
	output = false
}

matches(target, name) {
	split(target, ".")[1] == name
} else {
	target == name
}

check_member(attribute, search) {
	startswith(attribute.members[_], search)
} else {
	startswith(attribute.member, search)
}

check_member(attribute, search) {
	startswith(attribute.members[_], search)
} else {
	startswith(attribute.member, search)
}

matches(target, name) {
	split(target, ".")[1] == name
} else {
	target == name
}

matches(target, name) {
	split(target, ".")[1] == name
} else {
	target == name
}


has_target_resource(bucketName, resourceName) {
	resource := input.document[i].resource[resourceName][_]

	split(resource.bucket, ".")[1] == bucketName
}

#Checks if an action is allowed for all principals
allows_action_from_all_principals(json_policy, action) {
 	policy := common_lib.json_unmarshal(json_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]
	statement.Effect == "Allow"
    anyPrincipal(statement)
    common_lib.containsOrInArrayContains(get_action(statement), action)
}

allows_all_s3_actions_from_all_principals_match(json_policy) {
    policy := common_lib.json_unmarshal(json_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]
	statement.Effect == "Allow"
	anyPrincipal(statement)
	action_matches_s3_star(get_action(statement))
}

get_action(statement) = a {
  statement.Action != null
  a := statement.Action
} else = a {
  statement.Actions != null
  a := statement.Actions
}

action_matches_s3_star(action_value) {
	is_string(action_value)
	action_is_s3_star_or_star(action_value)
}

action_matches_s3_star(action_value) {
	is_array(action_value)
	some i
	action_is_s3_star_or_star(action_value[i])
}

action_is_s3_star_or_star(action) {
	action == "*"
} else {
	action == "s3:*"
}

resourceFieldName = {
	"google_bigquery_dataset": "friendly_name",
	"alicloud_actiontrail_trail": "trail_name",
	"alicloud_ros_stack": "stack_name",
	"alicloud_oss_bucket": "bucket",
	"aws_s3_bucket": "bucket",
	"aws_msk_cluster": "cluster_name",
	"aws_mq_broker": "broker_name",
	"aws_elasticache_cluster": "cluster_id",
}

get_resource_name(resource, resourceDefinitionName) = name {
	name := resource["name"]
} else = name {
	name := resource["display_name"]
}  else = name {
	name := resource.metadata.name
} else = name {
	prefix := resource.name_prefix
	name := sprintf("%s<unknown-sufix>", [prefix])
} else = name {
	name := common_lib.get_tag_name_if_exists(resource)
} else = name {
	name := resourceDefinitionName
}

get_specific_resource_name(resource, resourceType, resourceDefinitionName) = name {
	field := resourceFieldName[resourceType]
	name := resource[field]
} else = name {
	name := get_resource_name(resource, resourceDefinitionName)
}

check_key_empty(disk_encryption_key) = key {
	common_lib.valid_key(disk_encryption_key, "raw_key")
	common_lib.emptyOrNull(disk_encryption_key.raw_key)
	key := "raw_key"
} else = key {
	common_lib.valid_key(disk_encryption_key, "kms_key_self_link")
	common_lib.emptyOrNull(disk_encryption_key.kms_key_self_link)
	key := "kms_key_self_link"
}
