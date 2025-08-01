package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	properties := resource.Properties
	lower(properties.Engine) == "redis"
	cf_lib.isCloudFormationFalse(properties.TransitEncryptionEnabled)
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.TransitEncryptionEnabled", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TransitEncryptionEnabled should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.TransitEncryptionEnabled is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	properties := resource.Properties
	resource.Type = "AWS::ElastiCache::ReplicationGroup"
	lower(properties.Engine) == "redis"
	not common_lib.valid_key(properties, "TransitEncryptionEnabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TransitEncryptionEnabled should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.TransitEncryptionEnabled is undefined", [key]),
	}
}
