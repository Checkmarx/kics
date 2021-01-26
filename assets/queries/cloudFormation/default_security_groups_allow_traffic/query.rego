package Cx

CxPolicy[result] {
	document := input.document
	resources := document[i].Resources[name]
	default_name := check_group_name(resources)
	default_name

	result := {
		"documentId": input.document[i].id,
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
