package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource["aws_s3_bucket_acl"][name]
	acl_policy := resource.access_control_policy
	is_array(acl_policy.grant)
	grant := acl_policy.grant[grant_index]
	grant.permission == "WRITE_ACP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket_acl", name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant[%d].permission", [name, grant_index ]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Should not be granted Write_ACP permission to the aws_s3_bucket_acl",
		"keyActualValue": "Write_ACP permission is granted to the aws_s3_bucket_acl",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "access_control_policy","grant",grant_index,"permission"  ], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource["aws_s3_bucket_acl"][name]
	acl_policy := resource.access_control_policy
	not is_array(acl_policy.grant)
	grant := acl_policy.grant
	grant.permission == "WRITE_ACP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket_acl", name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant.permission", [name ]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Should not be granted Write_ACP permission to the aws_s3_bucket_acl",
		"keyActualValue": "Write_ACP permission is granted to the aws_s3_bucket_acl",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "access_control_policy","grant","permission"  ], []),
	}
}
