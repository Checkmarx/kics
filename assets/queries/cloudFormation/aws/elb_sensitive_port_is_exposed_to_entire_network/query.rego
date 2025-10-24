package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resources := input.document[i].Resources

	elbInstance = resources[elb_instance_name]
	elbType := getELBType(elbInstance.Type)

	resource := resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	cf_lib.get_name(elbInstance.Properties.SecurityGroups[_]) == sec_group_name
	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, input.document[i])

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(resource.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	# check that it is exposed
	cidr_fields := {"CidrIp", "CidrIpv6"}
	endswith(ingress[cidr_fields[c]], "/0")

	# check which sensitive port numbers are included
	ports := get_sensitive_ports(ingress)

	results := cf_lib.get_search_values(ing_index, sec_group_name, ingresses_with_names.names)

	result := {
		"documentId": input.document[i].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(resource, sec_group_name),
		"searchKey": results.searchKey,
		"searchValue": ports[x].searchValue,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s should not be allowed in %s load balancer '%s'", [ports[x].value, elbType, elb_instance_name]),
		"keyActualValue": sprintf("%s is allowed in %v load balancer '%s'", [ports[x].value, elbType, elb_instance_name]),
		"searchLine": results.searchLine,
	}
}

get_sensitive_ports(ingress) = ports {
	ingress.IpProtocol == "-1"
	ports := [{
		"value" : "ALL PORTS (ALL PROTOCOLS:0-65535)",
		"searchValue" : "ALL PROTOCOLS,0-65535"
		}]
} else = ports {
	portName  := common_lib.tcpPortsMap[portNumber]
	protocol  := upper(ingress.IpProtocol)
	protocol  == ["TCP", "6", "UDP", "17"][_]
	cf_lib.containsPort(ingress.FromPort, ingress.ToPort, portNumber)

	ports := [x | x := {
		"value" : sprintf("%s (%s:%d)", [portName, protocol, portNumber]),
		"searchValue" : sprintf("%s,%d", [protocol, portNumber]),
		}]
}

getELBType("AWS::ElasticLoadBalancing::LoadBalancer") = "classic"
getELBType("AWS::ElasticLoadBalancingV2::LoadBalancer") = "application"
