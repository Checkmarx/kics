package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resources := input.document[i].Resources[name]
	ports := [20, 21, 22, 23, 115, 137, 138, 139, 2049, 3389]

	check_security_groups_ingress(resources.Properties, ports)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("None of the Resources.%s.Properties.SecurityGroupIngress has an exposed port", [name]),
		"keyActualValue": sprintf("One of the Resources.%s.Properties.SecurityGroupIngress has a too exposed port (20,21,22,23,115,137,138,2049,3389)", [name]),
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
