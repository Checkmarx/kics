package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	not common_lib.valid_key(resource.Properties, "StorageEncrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be defined and set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is undefined", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	properties := resource.Properties
	
	cf_lib.isCloudFormationFalse(properties.StorageEncrypted)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.StorageEncrypted", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is set to false", [name]),
	}
}
