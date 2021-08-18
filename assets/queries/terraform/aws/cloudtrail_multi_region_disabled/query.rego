package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	not common_lib.valid_key(cloudtrail, "is_multi_region_trail")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cloud Trail Multi Region is defined and not null",
		"keyActualValue": "Cloud Trail Multi Region is undefined or null",
	}
}

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	cloudtrail.is_multi_region_trail == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s].is_multi_region_trail", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Cloud Trail Multi Region is true",
		"keyActualValue": "Cloud Trail Multi Region is false",
	}
}
