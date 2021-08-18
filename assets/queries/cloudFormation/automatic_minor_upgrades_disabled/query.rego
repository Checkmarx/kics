package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	not common_lib.valid_key(resource.Properties, "AutoMinorVersionUpgrade")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	resource.Properties.AutoMinorVersionUpgrade == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AutoMinorVersionUpgrade", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is false", [name]),
	}
}
