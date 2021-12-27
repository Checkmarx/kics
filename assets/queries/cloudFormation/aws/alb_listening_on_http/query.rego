package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"

	resource.Properties.Listeners[_].Protocol == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Listeners.Protocol=HTTP", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Listeners.Protocol' not equal to 'HTTP'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Listeners.Protocol' equals to 'HTTP'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancingV2::Listener"

	protocol := resource.Properties.Protocol
	protocol == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Protocol' not equal to 'HTTP'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Protocol' equals to 'HTTP'", [name]),
	}
}
