package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	resource.enabled == true
	not resource.web_acl_id

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s].web_acl_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'web_acl_id'  should exist",
		"keyActualValue": "'web_acl_id' is missing",
	}
}
