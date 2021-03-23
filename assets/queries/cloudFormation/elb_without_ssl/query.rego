package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	resource.Properties.Listeners[_].InstanceProtocol != "HTTPS"
	resource.Properties.Listeners[_].Protocol != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Listeners", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Listeners.InstanceProtocol' and 'Resources.%s.Listeners.Protocol' is set to 'HTTPS'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Listeners.InstanceProtocol' or 'Resources.%s.Listeners.Protocol' isn't set to 'HTTPS'", [name]),
	}
}
