package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudtrail[name]
	resource.enable_logging == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudtrail.%s.enable_logging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail.%s.enable_logging is true", [name]),
		"keyActualValue": sprintf("aws_cloudtrail.%s.enable_logging is false", [name]),
	}
}
