package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_api_gateway_stage[name]
	not haveLogs(resource.stage_name)

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_cloudwatch_log_group' should be defined and use the correct naming convention",
		"keyActualValue": "'aws_cloudwatch_log_group' for the stage is not undefined or not using the correct naming convention",
	}
}

haveLogs(stageName) {
	some document in input.document
	some log in document.resource.aws_cloudwatch_log_group
	stageName_escaped := replace(replace(stageName, "$", "\\$"), ".", "\\.")
	regexPattern := sprintf("API-Gateway-Execution-Logs_\\${aws_api_gateway_rest_api\\.\\w+\\.id}/%s$", [stageName_escaped])
	regex.match(regexPattern, log.name)
}
