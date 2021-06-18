package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	properties := resource.Properties
	properties.IamAuthEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.IamAuthEnabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IamAuthEnabled is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IamAuthEnabled is set to false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	properties := resource.Properties

	object.get(properties, "IamAuthEnabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IamAuthEnabled is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IamAuthEnabled is undefined", [name]),
	}
}
