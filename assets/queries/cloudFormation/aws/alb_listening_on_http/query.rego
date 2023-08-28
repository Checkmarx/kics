package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"

	resource.Properties.Listeners[l].Protocol == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Listeners.Protocol=HTTP", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Listeners.Protocol' should not equal to 'HTTP'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Listeners.Protocol' equals to 'HTTP'", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties","Listeners",l,"Protocol"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancingV2::Listener"

	protocol := resource.Properties.Protocol
	protocol == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Protocol=HTTP", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Protocol' should not equal to 'HTTP'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Protocol' equals to 'HTTP'", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties","Protocol"], []),
	}
}
