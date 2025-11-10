package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

portsMaps := {"TCP": common_lib.tcpPortsMap, "UDP": cf_lib.udpPortsMap}

CxPolicy[result] {
	resources := input.document[i].Resources

	ec2Instance = resources[ec2_instance_name]
	ec2Instance.Type == "AWS::EC2::Instance"

	resource := resources[sec_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	cf_lib.get_name(ec2Instance.Properties.SecurityGroupIds[_]) == sec_group_name
	ingresses_with_names := cf_lib.search_for_standalone_ingress(sec_group_name, input.document[y])

	ingress_list := array.concat(ingresses_with_names.ingress_list, common_lib.get_array_if_exists(resource.Properties,"SecurityGroupIngress"))
	ingress := ingress_list[ing_index]

	# check that it is exposed
	cidr_fields := {"CidrIp", "CidrIpv6"}
	endswith(ingress[cidr_fields[c]], "/0")

	# check which sensitive port numbers are included
	ports := get_sensitive_ports(ingress, ec2_instance_name)

	results := cf_lib.get_search_values_for_ingress_resources(ing_index, sec_group_name, ingresses_with_names.names, y, i)

	result := {
		"documentId": input.document[results.doc_index].id,
		"resourceType": results.type,
		"resourceName": cf_lib.get_resource_name(resource, sec_group_name),
		"searchKey": results.searchKey,
		"searchValue": ports[x].searchValue,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s should not be allowed in EC2 security group for instance '%s'", [ports[x].value, ec2_instance_name]),
		"keyActualValue": sprintf("%s is allowed in EC2 security group for instance '%s'", [ports[x].value, ec2_instance_name]),
		"searchLine": results.searchLine,
	}
}

get_sensitive_ports(ingress, ec2_instance_name) = ports {
	ports := [x |
		protocol   := cf_lib.getProtocolList(ingress.IpProtocol)[_]
		portName   := portsMaps[protocol][portNumber]
		check_port(ingress.FromPort, ingress.ToPort, portNumber, ingress.IpProtocol)
		x := {
		"value" : sprintf("%s (%s:%d)", [portName, protocol, portNumber]),
		"searchValue" : sprintf("%s/%s:%d", [ec2_instance_name, protocol, portNumber])
		}]
}

check_port(from, to, port, protocol) {
	protocol == "-1"
} else {
	cf_lib.containsPort(from, to, port)
}
