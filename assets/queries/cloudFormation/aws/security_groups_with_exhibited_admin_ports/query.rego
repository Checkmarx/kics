package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

admin_ports := ["20", "21", "22", "23", "115", "137", "138", "139", "2049", "3389"]

CxPolicy[result] {
	resource := input.document[i].Resources[sec_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, input.document[y])

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(resource.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	cf_lib.entireNetwork(ingress)
	exposed_ports := get_exposed_ports(ingress)

	results := cf_lib.get_search_values_for_ingress_resources(ing_index, sec_group_name, ingresses_with_names.names, y, i)

	result := {
		"documentId": input.document[results.doc_index].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(resource, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "No exposed ingress rule should contain admin ports: 20, 21, 22, 23, 115, 137, 138, 139, 2049 or 3389",
		"keyActualValue": sprintf("'%s' is exposed and contains port(s): %s", [results.searchKey, concat(", ", exposed_ports)]),
		"searchLine": results.searchLine,
	}
}

get_exposed_ports(ingress) = admin_ports {
	ingress.IpProtocol == "-1"
} else = exposed_ports {
	exposed_ports := [admin_ports[i2] | cf_lib.containsPort(ingress.FromPort, ingress.ToPort, to_number(admin_ports[i2]))]
	exposed_ports != []
}
