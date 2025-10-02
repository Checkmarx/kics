package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources
	secGroup := resources[sec_group_name]
	secGroup.Type == "AWS::EC2::SecurityGroup"

	ingress := secGroup.Properties.SecurityGroupIngress[l]

	protocols := getProtocolList(ingress.IpProtocol)
	protocol := protocols[m]
	portsMap := {
		"TCP": common_lib.tcpPortsMap,
		"UDP": cf_lib.udpPortsMap,
	}

	isAccessibleFromEntireNetwork(ingress)

	portRange := numbers.range(ingress.FromPort, ingress.ToPort)
	portNumber := portRange[idx]
	portName := portsMap[protocol][portNumber]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(secGroup, sec_group_name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d]", [sec_group_name,l]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed", [portName, protocol, portNumber]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed", [portName, protocol, portNumber]),
		"searchLine": common_lib.build_search_line(["Resources", sec_group_name, "Properties", "SecurityGroupIngress", l], []),
	}
}

isAccessibleFromEntireNetwork(ingress) {
	endswith(ingress.CidrIp, "/0")
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
}
