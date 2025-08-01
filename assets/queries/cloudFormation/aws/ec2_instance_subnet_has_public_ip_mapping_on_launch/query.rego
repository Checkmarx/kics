package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::Subnet"
	cf_lib.isCloudFormationTrue(resource.Properties.MapPublicIpOnLaunch)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.MapPublicIpOnLaunch", [cf_lib.getPath(path),name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' should be false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' is true", [name]),
	}
}
