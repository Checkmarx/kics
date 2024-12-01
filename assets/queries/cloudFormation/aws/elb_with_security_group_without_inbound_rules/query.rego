package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]

	cf_lib.isLoadBalancer(resource)
	securityGroups := resource.Properties.SecurityGroups

	some sg
	securityGroup := securityGroups[sg]
	value := withoutOutboundRules(securityGroup)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties%s", [securityGroup, value.path]),
		"issueType": value.issue,
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is %s", [securityGroup, value.expected]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is %s", [securityGroup, value.actual]),
	}
}

withoutOutboundRules(securityGroupName) = result {
	some document in input.document
	securityGroup := document.Resources[securityGroupName]
	not common_lib.valid_key(securityGroup.Properties, "SecurityGroupIngress")
	result := {"expected": "defined", "actual": "undefined", "path": "", "issue": "MissingAttribute"}
}

withoutOutboundRules(securityGroupName) = result {
	some document in input.document
	securityGroup := document.Resources[securityGroupName]
	securityGroup.Properties.SecurityGroupIngress == []
	result := {"expected": "not empty", "actual": "empty", "path": ".SecurityGroupIngress", "issue": "IncorrectValue"}
}

withoutOutboundRules(securityGroupName) = result {
	some j
	some document in input.document
	resource := document.Resources[j]
	resource.Type == "AWS::EC2::SecurityGroupIngress"
	groupId := resource.Properties.GroupId
	id := replace(groupId, "!Ref ", "")
	not id == securityGroupName
	result := {"expected": "defined", "actual": "undefined", "path": "", "issue": "MissingAttribute"}
}
