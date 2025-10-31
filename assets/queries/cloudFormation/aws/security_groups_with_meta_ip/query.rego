package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[sec_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, input.document[y])

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(resource.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	cidr_types := {"CidrIp","CidrIpv6"}
	exposed_addresses := array.concat(["0.0.0.0/0"], common_lib.unrestricted_ipv6)
	ingress[cidr_types[c]] == exposed_addresses[a]

	key_string := check_security_groups_ingress(ingress)

	results := get_search_values(ing_index, sec_group_name, ingresses_with_names.names, cidr_types[c], y, i)

	result := {
		"documentId": input.document[results.doc_index].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(resource, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("No ingress should have a '%s' set to '%s' with %s.", [cidr_types[c], exposed_addresses[a], key_string]),
		"keyActualValue": sprintf("'%s' has %s equal to %s with %s.", [results.searchKey, cidr_types[c], exposed_addresses[a], key_string]),
		"searchLine": results.searchLine,
	}
}

check_security_groups_ingress(ingress) = "'IpProtocol' set to '-1'"{
	ingress.IpProtocol == "-1"
} else = "all 65535 ports open" {
	ingress.FromPort == 0
	ingress.ToPort == 65535
}

get_search_values(ing_index, sec_group_name, names_list, cidr_type, index_sec_document, index_main_document) = results {
	ing_index < count(names_list) # if ingress has name it is standalone

	results := {
		"searchKey" : sprintf("Resources.%s.Properties.%s", [names_list[ing_index], cidr_type]),
		"searchLine" : common_lib.build_search_line(["Resources", names_list[ing_index], "Properties", cidr_type], []),
		"doc_index" : index_sec_document,
		"type" : "AWS::EC2::SecurityGroupIngress"
	}
} else = results {  # else it is part of the "SecurityGroupIngress" array

	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].%s", [sec_group_name, ing_index - count(names_list), cidr_type]),
		"searchLine" : common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupIngress", ing_index - count(names_list), cidr_type], []),
		"doc_index" : index_main_document,
		"type" : "AWS::EC2::SecurityGroup"
	}
}
