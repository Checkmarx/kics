package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[key]
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	properties := resource.Properties
	lower(properties.Engine) == "redis"
	properties.AtRestEncryptionEnabled == false
	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.AtRestEncryptionEnabled", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AtRestEncryptionEnabled should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.AtRestEncryptionEnabled is false", [key]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[key]
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	properties := resource.Properties
	lower(properties.Engine) == "redis"
	not common_lib.valid_key(properties, "AtRestEncryptionEnabled")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AtRestEncryptionEnabled should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.AtRestEncryptionEnabled is undefined", [key]),
	}
}
