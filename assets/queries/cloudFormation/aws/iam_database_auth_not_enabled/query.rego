package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.EnableIAMDatabaseAuthentication)
	common_lib.valid_for_iam_engine_and_version_check(properties, "Engine", "EngineVersion", "DBInstanceClass")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.EnableIAMDatabaseAuthentication", [cf_lib.getPath(path),name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication should be true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication is false", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	not common_lib.valid_key(properties, "EnableIAMDatabaseAuthentication")
	common_lib.valid_for_iam_engine_and_version_check(properties, "Engine", "EngineVersion", "DBInstanceClass")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path),name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EnableIAMDatabaseAuthentication is not defined", [name]),
	}
}
