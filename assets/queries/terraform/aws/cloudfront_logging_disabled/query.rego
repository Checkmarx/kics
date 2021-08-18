package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource
	cloudfront := resource.aws_cloudfront_distribution[name]
	not common_lib.valid_key(cloudfront, "logging_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudfront_distribution[%s].logging_config is defined", [name]),
		"keyActualValue": sprintf("aws_cloudfront_distribution[%s].logging_config is undefined", [name]),
	}
}
