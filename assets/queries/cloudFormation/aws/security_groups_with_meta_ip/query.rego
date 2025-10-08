package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	sec_group := doc.Resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	ingresses_with_names := search_for_standalone_ingress(sec_group_name, doc)

	ingress_list := array.concat(ingresses_with_names.ingress_list, get_inline_ingress_list(sec_group))
	ingress := ingress_list[ing_index]

	cidr_types := {"CidrIp","CidrIpv6"}
	exposed_addresses := ["0.0.0.0/0", common_lib.unrestricted_ipv6[_]]
	ingress[cidr_types[c]] == exposed_addresses[a]

	key_string := check_security_groups_ingress(ingress)
	key_string != ""

	results := get_search_values(ing_index, sec_group_name, ingresses_with_names.names, cidr_types[c])

	result := {
		"documentId": doc.id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(sec_group, sec_group_name),
		"searchKey": results.searchKey, #sprintf("Resources.%s.Properties.SecurityGroupIngress.CidrIp", [name]),
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
} else = ""

search_for_standalone_ingress(sec_group_name, doc) = ingresses_with_names {
  resources := doc.Resources

  names := [name |
    ingress := resources[name]
    ingress.Type == "AWS::EC2::SecurityGroupIngress"
    cf_lib.get_name(ingress.Properties.GroupId) == sec_group_name
  ]

  ingresses_with_names := {
    "ingress_list": [resources[name].Properties | name := names[_]],
    "names": names
  }
} else = {"ingress_list": [], "names": []}

get_search_values(ing_index, sec_group_name, names_list, cidr_type) = results {
	ing_index < count(names_list) # if ingress is standalone 

	results := {
		"searchKey" : sprintf("Resources.%s.Properties.%s", [names_list[ing_index], cidr_type]),
		"searchLine" : common_lib.build_search_line(["Resources", names_list[ing_index], "Properties", cidr_type], []),
		"type" : "AWS::EC2::SecurityGroupIngress"
	}
} else = results {
	
	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].%s", [sec_group_name, ing_index - count(names_list), cidr_type]),
		"searchLine" : common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupIngress", ing_index - count(names_list), cidr_type], []),
		"type" : "AWS::EC2::SecurityGroup"
	}
}

get_inline_ingress_list(group) = [] {
	not common_lib.valid_key(group.Properties,"SecurityGroupIngress")
} else = group.Properties.SecurityGroupIngress