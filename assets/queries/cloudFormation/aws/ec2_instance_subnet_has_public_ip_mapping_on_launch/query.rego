package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::Subnet"
	resource.Properties.MapPublicIpOnLaunch == true

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.MapPublicIpOnLaunch", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' should be false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' is true", [name]),
	}
}
