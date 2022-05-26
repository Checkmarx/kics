package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resources := document[i].Resources[name]
	check_not_exists_vpc(resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.VpcId.Ref", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VpcId.Ref is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.VpcId.Ref is undefined", [name]),
	}
}

check_not_exists_vpc(resource) {
	resource.Type == "AWS::EC2::SecurityGroup"
	security_group := resource.Properties
	security_group.GroupName != "default"
	not common_lib.valid_key(security_group, "VpcId")
}
