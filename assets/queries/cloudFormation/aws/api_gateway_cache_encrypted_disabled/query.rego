package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	deployment := input.document[i].Resources[name]
	deployment.Type == "AWS::ApiGateway::Deployment"
	stageDescription := deployment.Properties.StageDescription

	not common_lib.valid_key(stageDescription, "CacheDataEncrypted")

	cf_lib.isCloudFormationTrue(stageDescription.CachingEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.Type,
		"resourceName": cf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("Resources.%s.Properties.StageDescription", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	deployment := input.document[i].Resources[name]
	deployment.Type == "AWS::ApiGateway::Deployment"
	stageDescription := deployment.Properties.StageDescription

	cf_lib.isCloudFormationFalse(stageDescription.CacheDataEncrypted)

	cf_lib.isCloudFormationTrue(stageDescription.CachingEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.Type,
		"resourceName": cf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("Resources.%s.Properties.StageDescription.CacheDataEncrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' should be set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is set to false", [name]),
	}
}
