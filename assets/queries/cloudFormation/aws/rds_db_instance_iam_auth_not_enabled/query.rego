package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	properties.EnableIAMDatabaseAuthentication == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication is false", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	not common_lib.valid_key(properties, "EnableIAMDatabaseAuthentication")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication is undefined", [name]),
	}
}
