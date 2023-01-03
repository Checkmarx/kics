package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudtrail[name]
	resource.enable_logging == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudtrail.%s.enable_logging", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudtrail", name, "enable_logging"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail.%s.enable_logging should be true", [name]),
		"keyActualValue": sprintf("aws_cloudtrail.%s.enable_logging is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
