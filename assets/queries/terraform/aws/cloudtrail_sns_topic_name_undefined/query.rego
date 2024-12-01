package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	cloudtrail := document.resource.aws_cloudtrail[name]

	isUndefined(cloudtrail)

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(cloudtrail, name),
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_cloudtrail[%s].sns_topic_name' should be set and should not be null", [name]),
		"keyActualValue": sprintf("'aws_cloudtrail[%s].sns_topic_name' is undefined or null", [name]),
	}
}

isUndefined(resource) {
	not common_lib.valid_key(resource, "sns_topic_name")
}
