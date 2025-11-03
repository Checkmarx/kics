package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[sec_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, input.document[y])

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(resource.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	cf_lib.entireNetwork(ingress)

	containsUnknownPort(ingress)

	results := cf_lib.get_search_values_for_ingress_resources(ing_index, sec_group_name, ingresses_with_names.names, y, i)

	result := {
		"documentId": input.document[results.doc_index].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(resource, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not open unknown ports to the Internet", [results.searchKey]),
		"keyActualValue": sprintf("'%s' opens unknown ports to the Internet", [results.searchKey]),
		"searchLine": results.searchLine,
	}
}

containsUnknownPort(ingress) {
	ingress.IpProtocol == "-1"
} else {
	port := numbers.range(ingress.FromPort, ingress.ToPort)[_]
	not common_lib.valid_key(common_lib.tcpPortsMap, port)
}
