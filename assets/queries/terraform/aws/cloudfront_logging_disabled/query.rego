package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	cloudfront := resource.aws_cloudfront_distribution[name]
	cloudfront.enabled == true
	not common_lib.valid_key(cloudfront, "logging_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudfront_distribution[%s].logging_config should be defined", [name]),
		"keyActualValue": sprintf("aws_cloudfront_distribution[%s].logging_config is undefined", [name]),
	}
}
