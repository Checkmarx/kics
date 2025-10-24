package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.Resources

	ec2Instance = resources[ec2_instance_name]
	ec2Instance.Type == "AWS::EC2::Instance"

	sec_group := resources[sec_group_name]
	sec_group.Type == "AWS::EC2::SecurityGroup"

	cf_lib.get_name(ec2Instance.Properties.SecurityGroupIds[_]) == sec_group_name
	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, doc)

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(sec_group.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	# check that it is exposed
	cidr_fields := {"CidrIp", "CidrIpv6"}
	endswith(ingress[cidr_fields[c]], "/0")

	# check which sensitive port numbers are included
	ports := get_sensitive_ports(ingress)

	results := cf_lib.get_search_values(ing_index, sec_group_name, ingresses_with_names.names)

	result := {
		"documentId": doc.id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(sec_group, sec_group_name),
		"searchKey": results.searchKey,
		"searchValue": ports[x].searchValue,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s should not be allowed in EC2 security group for instance '%s'", [ports[x].value, ec2_instance_name]),
		"keyActualValue": sprintf("%s is allowed in EC2 security group for instance '%s'", [ports[x].value, ec2_instance_name]),
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
	portName   := common_lib.tcpPortsMap[portNumber]
	protocol  := upper(ingress.IpProtocol)
	protocol  == ["TCP", "6", "UDP", "17"][_]
	cf_lib.containsPort(ingress.FromPort, ingress.ToPort, portNumber)

	ports := [x | x := {
		"value" : sprintf("%s (%s:%d)", [portName, protocol, portNumber]),
		"searchValue" : sprintf("%s,%d", [protocol, portNumber]),
		}]
}
