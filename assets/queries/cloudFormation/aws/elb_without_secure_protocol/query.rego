package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some name, idx
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"

	listener := resource.Properties.Listeners[idx]

	protocols := {"InstanceProtocol", "Protocol"}
	some protocol in protocols
	not is_secure(listener, protocol)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Listeners", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Listeners.%s' should be set to 'SSL' or 'HTTPS'", [name, protocol]),
		"keyActualValue": sprintf("'Resources.%s.Listeners.%s' isn't set to 'SSL' or 'HTTPS'", [name, protocol]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Listeners", idx], [protocol]),
	}
}

is_secure(listener, protocol) {
	secureProtocols := {"SSL", "HTTPS"}
	listener[protocol] == secureProtocols[_]
}
