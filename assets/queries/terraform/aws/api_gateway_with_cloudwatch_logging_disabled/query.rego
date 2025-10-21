package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_api_gateway_stage[name]

	results := get_results(resource,doc,name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "MissingAttribute",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

get_results(resource,doc,name) = results {
	not resource.access_log_settings.destination_arn
	results := does_not_have_valid_stage_name(resource,doc,name)
} else = results {
	r2 := does_not_have_valid_stage_name(resource,doc,name)
	results := does_not_have_valid_destination_arn(resource,doc,name)
}

does_not_have_valid_destination_arn(resource,doc,name) = results {
	not haveLogs_destination_arn(resource,doc)
	results := {
		"searchKey": sprintf("aws_api_gateway_stage[%s].access_log_settings.destination_arn", [name]),
		"keyExpectedValue": sprintf("'aws_api_gateway_stage[%s].access_log_settings.destination_arn' should reference a valid 'aws_cloudwatch_log_group' arn",[name]),
		"keyActualValue": sprintf("'aws_api_gateway_stage[%s].access_log_settings.destination_arn' does not reference a valid 'aws_cloudwatch_log_group' arn",[name]),
		"searchLine": common_lib.build_search_line(["resource","aws_api_gateway_stage", name, "access_log_settings", "destination_arn"],[])
	}
}

does_not_have_valid_stage_name(resource,doc,name) = results {
	not haveLogs_stageName(resource,doc)
	results := {
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"keyExpectedValue": sprintf("'aws_cloudwatch_log_group' for 'aws_api_gateway_stage[%s]' should be defined and use the correct naming convention",[name]),
		"keyActualValue": sprintf("'aws_cloudwatch_log_group' for 'aws_api_gateway_stage[%s]' is undefined or is not using the correct naming convention",[name]),
		"searchLine": common_lib.build_search_line(["resource","aws_api_gateway_stage", name],[])
	}
}

haveLogs_stageName(resource,doc) {
	log := doc.resource.aws_cloudwatch_log_group[_]
	stageName_escaped := replace(replace(resource.stage_name, "$", "\\$"), ".", "\\.")
	regexPattern := sprintf("API-Gateway-Execution-Logs_\\${aws_api_gateway_rest_api\\.\\w+\\.id}/%s$", [stageName_escaped])
	regex.match(regexPattern, log.name)
}

haveLogs_destination_arn(resource,doc) {
	common_lib.valid_key(resource.access_log_settings,"destination_arn")

	destination_arn := resource.access_log_settings.destination_arn

	log_group := doc.resource.aws_cloudwatch_log_group[name]
	regexPattern := sprintf("aws_cloudwatch_log_group.%s.arn", [name])
	regex.match(regexPattern, destination_arn)
	common_lib.valid_key(log_group,"name")
}
