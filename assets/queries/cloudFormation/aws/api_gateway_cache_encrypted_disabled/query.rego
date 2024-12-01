package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	deployment := doc.Resources[name]
	deployment.Type == "AWS::ApiGateway::Deployment"
	stageDescription := deployment.Properties.StageDescription

	not common_lib.valid_key(stageDescription, "CacheDataEncrypted")

	stageDescription.CachingEnabled == true

	result := {
		"documentId": doc.id,
		"resourceType": deployment.Type,
		"resourceName": cf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("Resources.%s.Properties.StageDescription", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	deployment := doc.Resources[name]
	deployment.Type == "AWS::ApiGateway::Deployment"
	stageDescription := deployment.Properties.StageDescription

	stageDescription.CacheDataEncrypted == false

	stageDescription.CachingEnabled == true

	result := {
		"documentId": doc.id,
		"resourceType": deployment.Type,
		"resourceName": cf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("Resources.%s.Properties.StageDescription.CacheDataEncrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' should be set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.StageDescription.CacheDataEncrypted' is set to false", [name]),
	}
}
