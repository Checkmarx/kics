package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	properties := resource.Properties
	lower(properties.Engine) == "redis"
	properties.AtRestEncryptionEnabled == false
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.properties.AtRestEncryptionEnabled", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.properties.AtRestEncryptionEnabled should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.AtRestEncryptionEnabled is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	properties := resource.Properties
	lower(properties.Engine) == "redis"
	object.get(properties, "AtRestEncryptionEnabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.properties.AtRestEncryptionEnabled should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.AtRestEncryptionEnabled is undefined", [key]),
	}
}
