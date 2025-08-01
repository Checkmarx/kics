package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	not common_lib.valid_key(resource.Properties, "AutoMinorVersionUpgrade")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is undefined", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	cf_lib.isCloudFormationFalse(resource.Properties.AutoMinorVersionUpgrade)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.AutoMinorVersionUpgrade", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is false", [name]),
	}
}
