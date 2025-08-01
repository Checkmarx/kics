package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.StorageEncrypted)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.StorageEncrypted", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be set to True", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is False", [name]),
		"searchLine": common_lib.build_search_line(path, ["Properties", "StorageEncrypted"]),
	}
}
