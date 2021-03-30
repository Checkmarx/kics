package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	properties.DeletionProtection == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DeletionProtection", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DeletionProtection is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DeletionProtection is false", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	object.get(properties, "DeletionProtection", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DeletionProtection is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DeletionProtection is undefined", [name]),
	}
}
