package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	deployment := input.document[i].Resources[name]
	deployment.Type == "AWS::ApiGateway::Deployment"
	stageDescription := deployment.Properties.StageDescription

	not common_lib.valid_key(stageDescription, "CacheDataEncrypted")

	stageDescription.CachingEnabled == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StageDescription", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	deployment := input.document[i].Resources[name]
	deployment.Type == "AWS::ApiGateway::Deployment"
	stageDescription := deployment.Properties.StageDescription

	stageDescription.CacheDataEncrypted == false

	stageDescription.CachingEnabled == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StageDescription.CacheDataEncrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is set to false", [name]),
	}
}
