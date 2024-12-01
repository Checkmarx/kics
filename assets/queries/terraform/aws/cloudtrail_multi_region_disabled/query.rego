package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	cloudtrail := document.resource.aws_cloudtrail[name]
	not common_lib.valid_key(cloudtrail, "is_multi_region_trail")

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(cloudtrail, name),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudtrail", name], []),
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail is undefined or null", [name]),
		"remediation": "is_multi_region_trail = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	cloudtrail := document.resource.aws_cloudtrail[name]
	cloudtrail.is_multi_region_trail == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(cloudtrail, name),
		"searchKey": sprintf("aws_cloudtrail[%s].is_multi_region_trail", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudtrail", name, "is_multi_region_trail"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail should be set to true", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail is set to false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some document in input.document
	cloudtrail := document.resource.aws_cloudtrail[name]
	cloudtrail.include_global_service_events == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(cloudtrail, name),
		"searchKey": sprintf("aws_cloudtrail[%s].include_global_service_events", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudtrail", name, "include_global_service_events"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].include_global_service_events should be undefined or set to true", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].include_global_service_events is set to false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
