package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::CloudWatch::Alarm"

	properties := resource.Properties

	not common_lib.valid_key(properties, "Metrics")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Metrics should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Metrics is undefined", [key]),
	}
}
