package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	cloudtrail := doc.resource.aws_cloudtrail[name]
	not common_lib.valid_key(cloudtrail, "is_multi_region_trail")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail is defined and not null", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail is undefined or null", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	cloudtrail := doc.resource.aws_cloudtrail[name]
	cloudtrail.is_multi_region_trail == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_cloudtrail[%s].is_multi_region_trail", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail is set to true", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].is_multi_region_trail is set to false", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	cloudtrail := doc.resource.aws_cloudtrail[name]
	cloudtrail.include_global_service_events == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_cloudtrail[%s].include_global_service_events", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].include_global_service_events undefined or is set to true", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].include_global_service_events is set to false", [name]),
	}
}
