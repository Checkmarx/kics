package Cx

import data.generic.cloudformation as cloudFormationLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	cloudFormationLib.isLoadBalancer(resource)
	securityGroups := resource.Properties.SecurityGroups

	some sg
	securityGroup := securityGroups[sg]
	value := withoutOutboundRules(securityGroup)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties%s", [securityGroup, value.path]),
		"issueType": value.issue,
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupEgress' is %s", [securityGroup, value.expected]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupEgress' is %s", [securityGroup, value.actual]),
	}
}

withoutOutboundRules(securityGroupName) = result {
	securityGroup := input.document[i].Resources[securityGroupName]
	object.get(securityGroup.Properties, "SecurityGroupEgress", "undefined") == "undefined"
	result := {"expected": "defined", "actual": "undefined", "path": "", "issue": "MissingAttribute"}
}

withoutOutboundRules(securityGroupName) = result {
	securityGroup := input.document[i].Resources[securityGroupName]
	securityGroup.Properties.SecurityGroupEgress == []
	result := {"expected": "not empty", "actual": "empty", "path": ".SecurityGroupEgress", "issue": "IncorrectValue"}
}
