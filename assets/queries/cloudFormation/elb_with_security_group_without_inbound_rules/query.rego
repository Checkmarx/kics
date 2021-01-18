package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	isLoadBalancer(resource)
	securityGroups := resource.Properties.SecurityGroups

	some sg
	securityGroup := securityGroups[sg]
	value := withoutOutboundRules(securityGroup)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties%s", [securityGroup, value.path]),
		"issueType": value.issue,
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is %s", [securityGroup, value.expected]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is %s", [securityGroup, value.actual]),
	}
}

isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
}

isLoadBalancer(resource) {
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
}

withoutOutboundRules(securityGroupName) = result {
	securityGroup := input.document[i].Resources[securityGroupName]
	object.get(securityGroup.Properties, "SecurityGroupIngress", "undefined") == "undefined"
	result := {"expected": "defined", "actual": "undefined", "path": "", "issue": "MissingAttribute"}
}

withoutOutboundRules(securityGroupName) = result {
	securityGroup := input.document[i].Resources[securityGroupName]
	securityGroup.Properties.SecurityGroupIngress == []
	result := {"expected": "not empty", "actual": "empty", "path": ".SecurityGroupIngress", "issue": "IncorrectValue"}
}
