package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resources := input.document[i].Resources[name]
	check_security_groups_ingress(resources.Properties)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress.CidrIp", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("None of the Resources.%s.Properties.SecurityGroupIngress has CidrIp equal to 0.0.0.0/0, FromPort to 0 and ToPort to 65535.", [name]),
		"keyActualValue": sprintf("One of the Resources.%s.Properties.SecurityGroupIngress has CidrIp equal to 0.0.0.0/0, FromPort to 0 and ToPort to 65535.", [name]),
	}
}

check_security_groups_ingress(group) {
	group.SecurityGroupIngress[_].CidrIp == "0.0.0.0/0"
	group.SecurityGroupIngress[_].FromPort == 0
	group.SecurityGroupIngress[_].ToPort == 65535
}
