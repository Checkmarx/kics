package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	common_lib.valid_key(resource.Properties, "IsLogging")
	resource.Properties.IsLogging == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.IsLogging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsLogging' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsLogging' is false", [name]),
	}
}
