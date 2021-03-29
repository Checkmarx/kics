package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::RDS::DBCluster"
	resource.Properties.StorageEncrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StorageEncrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is false", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::RDS::DBCluster"
	object.get(resource.Properties, "StorageEncrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StorageEncrypted", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is undefined", [name]),
	}
}
