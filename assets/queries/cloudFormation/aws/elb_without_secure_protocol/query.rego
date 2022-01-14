package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"

	listener := resource.Properties.Listeners[idx]

	protocols := {"InstanceProtocol", "Protocol"}
	protocol := protocols[p]
	not is_secure(listener, protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Listeners", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Listeners.%s' is set to 'SSL' or 'HTTPS'", [name, protocol]),
		"keyActualValue": sprintf("'Resources.%s.Listeners.%s' isn't set to 'SSL' or 'HTTPS'", [name, protocol]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Listeners", idx], [protocol]),
	}
}


is_secure(listener, protocol) {
	secureProtocols := {"SSL", "HTTPS"}
	listener[protocol] == secureProtocols[_]
}
