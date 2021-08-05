package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EC2::Volume"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Encrypted")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EC2::Volume"
	properties := resource.Properties
	properties.Encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is false", [name]),
	}
}
