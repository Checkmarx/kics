package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	cf_lib.isLoadBalancer(resource)
	securityGroups := resource.Properties.SecurityGroups

	some sg
	securityGroup := securityGroups[sg]
	value := withoutOutboundRules(securityGroup)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties%s", [securityGroup, value.path]),
		"issueType": value.issue,
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupEgress' is %s", [securityGroup, value.expected]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupEgress' is %s", [securityGroup, value.actual]),
	}
}

withoutOutboundRules(securityGroupName) = result {
	securityGroup := input.document[i].Resources[securityGroupName]
	not common_lib.valid_key(securityGroup.Properties, "SecurityGroupEgress")
	result := {"expected": "defined", "actual": "undefined", "path": "", "issue": "MissingAttribute"}
}

withoutOutboundRules(securityGroupName) = result {
	securityGroup := input.document[i].Resources[securityGroupName]
	securityGroup.Properties.SecurityGroupEgress == []
	result := {"expected": "not empty", "actual": "empty", "path": ".SecurityGroupEgress", "issue": "IncorrectValue"}
}
