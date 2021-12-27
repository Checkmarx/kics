package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"

	not common_lib.valid_key(resource.Properties, "Encrypted")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Redshift::Cluster"

	properties := resource.Properties

	properties.Encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encryped is set to false", [name]),
	}
}
