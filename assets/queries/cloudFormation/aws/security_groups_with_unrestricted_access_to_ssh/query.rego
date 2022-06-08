package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resources := document[i].Resources[name]
	port := 22

	check_security_groups_ingress(resources.Properties, port)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("None of the Resources.%s.Properties.SecurityGroupIngress has port %d", [name, port]),
		"keyActualValue": sprintf("One of the Resources.%s.Properties.SecurityGroupIngress has port %d", [name, port]),
	}
}

check_security_groups_ingress(group, port) {
	some j
	group.SecurityGroupIngress[j].CidrIp == "0.0.0.0/0"
	group.SecurityGroupIngress[j].FromPort == port
}

check_security_groups_ingress(group, port) {
	some j
	group.SecurityGroupIngress[j].CidrIp == "0.0.0.0/0"
	group.SecurityGroupIngress[j].ToPort == port
}
