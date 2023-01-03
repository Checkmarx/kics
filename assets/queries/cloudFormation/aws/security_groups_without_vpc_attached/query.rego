package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	check_not_exists_vpc(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.VpcId.Ref", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VpcId.Ref should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.VpcId.Ref is undefined", [name]),
	}
}

check_not_exists_vpc(resource) {
	resource.Type == "AWS::EC2::SecurityGroup"
	security_group := resource.Properties
	security_group.GroupName != "default"
	not common_lib.valid_key(security_group, "VpcId")
}
