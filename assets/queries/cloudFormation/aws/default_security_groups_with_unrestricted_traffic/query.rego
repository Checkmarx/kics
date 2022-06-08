package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resources := document[i].Resources[name]
	check_group_name(resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.GroupName is defined as default and the inbound and outbound rules are empty.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.GroupName is defined as default and the inbound and outbound rules are not empty.", [name]),
	}
}

check_group_name(resource) {
	resource.Type == "AWS::EC2::SecurityGroup"
	security_group := resource.Properties
	security_group.GroupName == "default"
	check_rules(security_group)
}

check_rules(security_group) {
	count(security_group.SecurityGroupIngress) != 0
}

check_rules(security_group) {
	count(security_group.SecurityGroupEgress) != 0
}
