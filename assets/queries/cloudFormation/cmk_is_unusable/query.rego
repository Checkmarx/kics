package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	object.get(resource.Properties, "Enabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Enabled' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Enabled' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.Enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Enabled' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Enabled' is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.PendingWindowInDays

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PendingWindowInDays", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PendingWindowInDays' is undefined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PendingWindowInDays' is defined", [name]),
	}
}
