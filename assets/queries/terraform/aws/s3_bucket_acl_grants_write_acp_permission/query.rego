package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_s3_bucket_acl[name]
	acl_policy := resource.access_control_policy
	is_array(acl_policy.grant)
	grant := acl_policy.grant[grant_index]
	grant.permission == "WRITE_ACP"

	result := {
		"documentId": document.id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket_acl", name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant[%d].permission", [name, grant_index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Should not be granted Write_ACP permission to the aws_s3_bucket_acl",
		"keyActualValue": "Write_ACP permission is granted to the aws_s3_bucket_acl",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "access_control_policy", "grant", grant_index, "permission"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_s3_bucket_acl[name]
	acl_policy := resource.access_control_policy
	not is_array(acl_policy.grant)
	grant := acl_policy.grant
	grant.permission == "WRITE_ACP"

	result := {
		"documentId": document.id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket_acl", name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant.permission", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Should not be granted Write_ACP permission to the aws_s3_bucket_acl",
		"keyActualValue": "Write_ACP permission is granted to the aws_s3_bucket_acl",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "access_control_policy", "grant", "permission"], []),
	}
}
