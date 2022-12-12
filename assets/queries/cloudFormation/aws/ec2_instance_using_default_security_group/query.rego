package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	sgs := {"SecurityGroups", "SecurityGroupsIds"}

	sgInfo := resource.Properties[sgs[s]][idx]

	contains(lower(get_sg_name(sgInfo)), "default")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.%s", [name, sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' should not be using default security group", [name, sgs[s]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' is using default security group", [name, sgs[s]]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", sgs[s]], [idx]),
	}
}

get_sg_name(sgInfo) = name {
	common_lib.valid_key(sgInfo, "Ref")
	name := sgInfo.Ref
} else = name {
	not common_lib.valid_key(sgInfo, "Ref")
	name := sgInfo
}
