package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.IamAuthEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.IamAuthEnabled", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IamAuthEnabled should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IamAuthEnabled is set to false", [name]),
		"searchLine": common_lib.build_search_line(path, ["Properties", "IamAuthEnabled"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	properties := resource.Properties

	not common_lib.valid_key(properties, "IamAuthEnabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IamAuthEnabled should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IamAuthEnabled is undefined", [name]),
		"searchLine": common_lib.build_search_line(path, [name,"Properties"]),
	}
}
