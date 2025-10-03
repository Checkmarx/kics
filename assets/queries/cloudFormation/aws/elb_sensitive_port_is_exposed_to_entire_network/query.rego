package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.Resources

	elbInstance = resources[elb_instance_name]
	contains(elbInstance.Type, "ElasticLoadBalancing")
	elbType := getELBType(elbInstance)

	sec_group := resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	cf_lib.get_name(elbInstance.Properties.SecurityGroups[_]) == sec_group_name
	ingresses_with_names := search_for_standalone_ingress(sec_group_name, doc)

	ingress_list := array.concat(ingresses_with_names.ingress_list, get_inline_ingress_list(sec_group))
	ingress := ingress_list[ing_index]

	# check that it is exposed
	cidr_fields := {"CidrIp", "CidrIpv6"}
	endswith(ingress[cidr_fields[c]], "/0")

	# get relevant ports for protocol(s)
	protocols := getProtocolList(ingress.IpProtocol)
	protocol := protocols[m]
	portsMap := common_lib.tcpPortsMap

	#check which sensitive port numbers are included
	portRange := numbers.range(ingress.FromPort, ingress.ToPort)
	portNumber := portRange[idx]
	portName := portsMap[portNumber]

	results := get_search_values(ing_index, sec_group_name, ingresses_with_names.names)

	result := {
		"documentId": input.document[i].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(sec_group, sec_group_name),
		"searchKey": results.searchKey,
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s load balancer '%s'", [portName, protocol, portNumber, elbType, elb_instance_name]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in %v load balancer '%s'", [portName, protocol, portNumber, elbType, elb_instance_name]),
		"searchLine": results.searchLine,
	}
}

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
} else = { "ingress_list": [], "names": []}

get_search_values(ing_index, sec_group_name, names_list) = results {
	ing_index < count(names_list) # if ingress is standalone 

	results := {
		"searchKey" : sprintf("Resources.%s.Properties", [names_list[ing_index]]),
		"searchLine" : common_lib.build_search_line(["Resources", names_list[ing_index], "Properties"], []),
		"type" : "AWS::EC2::SecurityGroupIngress"
	}
} else = results {
	
	results := {
		"searchKey" : sprintf("Resources.%s.Properties.SecurityGroupIngress[%d]", [sec_group_name, ing_index]),
		"searchLine" : common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupIngress", ing_index], []),
		"type" : "AWS::EC2::SecurityGroup"
	}
}

getProtocolList(protocol) = list {
	protocol == "-1"
	list = ["TCP", "UDP"]
} else = list {
	upper(protocol) == "TCP"
	list = ["TCP"]
} else = list {
	upper(protocol) == "UDP"
	list = ["UDP"]
} else = []

getELBType(elb) = type {
	common_lib.valid_key(elb.Properties, "Type")
	type = elb.Properties.Type
} else = type {
	elb.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	type = "classic"
} else = type {
	elb.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
	type = "application"
}

get_inline_ingress_list(group) = [] {
	not common_lib.valid_key(group.Properties,"SecurityGroupIngress")
} else = group.Properties.SecurityGroupIngress
