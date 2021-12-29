package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	sgs := {"SecurityGroups", "SecurityGroupsIds"}

	sgInfo := resource.Properties[sgs[s]][idx]

	contains(lower(get_sg_name(sgInfo)), "default")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.%s", [name, sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' is not using default security group", [name, sgs[s]]),
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
