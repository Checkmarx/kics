package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_stage[name]
	not haveLogs(resource.stage_name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_cloudwatch_log_group' should be defined and use the correct naming convention",
		"keyActualValue": "'aws_cloudwatch_log_group' for the stage is not undefined or not using the correct naming convention",
	}
}

haveLogs(stageName) {
	log := input.document[i].resource.aws_cloudwatch_log_group[_]
	stageName_escaped := replace(replace(stageName, "$", "\\$"), ".", "\\.")
	regexPattern := sprintf("API-Gateway-Execution-Logs_\\${aws_api_gateway_rest_api\\.\\w+\\.id}/%s$", [stageName_escaped])
	regex.match(regexPattern, log.name)
}
