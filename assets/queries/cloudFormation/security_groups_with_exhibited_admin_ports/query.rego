package Cx

CxPolicy[result] {
	document := input.document
	resources := input.document[i].Resources[name]
	ports := [20, 21, 22, 23, 115, 137, 138, 139, 2049, 3389]

	check_security_groups_ingress(resources.Properties, ports)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("None of the Resources.%s.Properties.SecurityGroupIngress has a correct port", [name]),
		"keyActualValue": sprintf("One of the Resources.%s.Properties.SecurityGroupIngress has a too exposed port", [name]),
	}
}

check_security_groups_ingress(group, ports) {
	some p
	group.SecurityGroupIngress[_].FromPort == ports[p]
}

check_security_groups_ingress(group, ports) {
	some p
	group.SecurityGroupIngress[_].ToPort == ports[p]
}
