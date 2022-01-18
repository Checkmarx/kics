package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.Enabled == true
	not common_lib.valid_key(resource.Properties, "PendingWindowInDays")
	not common_lib.valid_key(resource.Properties, "EnableKeyRotation")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.Enabled == true
	not common_lib.valid_key(resource.Properties, "PendingWindowInDays")
	resource.Properties.EnableKeyRotation == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EnableKeyRotation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is false", [name]),
	}
}
