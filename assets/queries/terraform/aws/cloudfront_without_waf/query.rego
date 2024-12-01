package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_cloudfront_distribution[name]
	resource.enabled == true
	not resource.web_acl_id

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s].web_acl_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'web_acl_id'  should exist",
		"keyActualValue": "'web_acl_id' is missing",
	}
}
