package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.DeletionProtection)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DeletionProtection", [cf_lib.getPath(path),name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DeletionProtection should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DeletionProtection is set to false", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	not common_lib.valid_key(properties, "DeletionProtection")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path),name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DeletionProtection should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DeletionProtection is undefined", [name]),
	}
}
