package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	ports := [20, 21, 22, 23, 115, 137, 138, 139, 2049, 3389]

	check_cidrip(resource.Properties)
	check_security_groups_ingress(resource.Properties, ports)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupIngress", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("None of the Resources.%s.Properties.SecurityGroupIngress should have an exposed port", [name]),
		"keyActualValue": sprintf("One of the Resources.%s.Properties.SecurityGroupIngress has a exposed port (20,21,22,23,115,137,138,2049,3389)", [name]),
	}
}

check_cidrip(group) {
	group.SecurityGroupIngress[_].CidrIp == "0.0.0.0/0"
}

check_security_groups_ingress(group, ports) {
	some p
	group.SecurityGroupIngress[_].FromPort == ports[p]
}

check_security_groups_ingress(group, ports) {
	some p
	group.SecurityGroupIngress[_].ToPort == ports[p]
}
