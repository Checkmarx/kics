package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	not common_lib.valid_key(resource.Properties, "AutoMinorVersionUpgrade")

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is undefined", [name]),
	}
}

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	resource.Properties.AutoMinorVersionUpgrade == false

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.AutoMinorVersionUpgrade", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AutoMinorVersionUpgrade' is false", [name]),
	}
}
