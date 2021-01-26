package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	policyName := resource.Properties.Policies[j].PolicyName
	protocol := resource.Properties.Policies[j].Attributes[k].Name
	check_vulnerability(protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Policies.PolicyName=%s.Attributes.Name=%s", [name, policyName, protocol]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Policies.%s.Attributes.%s' is not an insecure protocol", [name, policyName, protocol]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Policies.%s.Attributes.%s' is an insecure protocol", [name, policyName, protocol]),
	}
}

check_vulnerability(protocol) {
	insecure_protocols = {"Protocol-SSLv2", "Protocol-SSLv3", "Protocol-TLSv1", "Protocol-TLSv1.1"}
	protocol == insecure_protocols[_]
}
