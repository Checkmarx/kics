package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	check_group_name(resource)

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.GroupName should be defined as default and the inbound and outbound rules should be empty.", [name]),
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
