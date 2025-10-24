package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	sec_group := doc.Resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	egresses_with_names := search_for_standalone_egress(sec_group_name, doc)

	egress_list := array.concat(egresses_with_names.egress_list, common_lib.get_array_if_exists(sec_group.Properties,"SecurityGroupEgress"))
	egress := egress_list[eg_index]

	egress.IpProtocol == "-1"

	cidr_types := {"CidrIp", "CidrIpv6"}
	exposed_addresses := ["0.0.0.0/0", common_lib.unrestricted_ipv6[_]]
	egress[cidr_types[c]] == exposed_addresses[a]

	results := get_search_values_egress(eg_index, sec_group_name, egresses_with_names.names)

	result := {
		"documentId": doc.id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(sec_group, sec_group_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not have IpProtocol set to '-1' and %s set to '%s' simultaneously", [results.searchKey, cidr_types[c], exposed_addresses[a]]),
		"keyActualValue": sprintf("'%s' has IpProtocol set to '-1' and %s set to '%s'.", [results.searchKey, cidr_types[c], exposed_addresses[a]]),
		"searchLine": results.searchLine,
	}
}

search_for_standalone_egress(sec_group_name, doc) = egresses_with_names {
  resources := doc.Resources

  names := [name |
    egress := resources[name]
    egress.Type == "AWS::EC2::SecurityGroupEgress"
    cf_lib.get_name(egress.Properties.GroupId) == sec_group_name
  ]

  egresses_with_names := {
    "egress_list": [resources[name].Properties | name := names[_]],
    "names": names
  }
} else = {"egress_list": [], "names": []}

get_search_values_egress(eg_index, sec_group_name, names_list) = results {
	eg_index < count(names_list) # if egress is standalone

	results := {
		"searchKey" : sprintf("Resources.%s.Properties", [names_list[eg_index]]),
		"searchLine" : common_lib.build_search_line(["Resources", names_list[eg_index], "Properties"], []),
		"type" : "AWS::EC2::SecurityGroupEgress"
	}
} else = results {

	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupEgress[%d]", [sec_group_name, eg_index - count(names_list)]),
		"searchLine" : common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupEgress", eg_index - count(names_list)], []),
		"type" : "AWS::EC2::SecurityGroup"
	}
}
