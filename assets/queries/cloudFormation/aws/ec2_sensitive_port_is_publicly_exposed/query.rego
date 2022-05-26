package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as commonLib

isAccessibleFromEntireNetwork(ingress) {
	endswith(ingress.CidrIp, "/0")
}

getProtocolList(protocol) = list {
	upper(protocol) == ["-1", "ALL"][_]
	list = ["TCP", "UDP"]
} else = list {
	upper(protocol) == "TCP"
	list = ["TCP"]
} else = list {
	upper(protocol) == "UDP"
	list = ["UDP"]
}

getProtocolPorts(protocols, tcpPortsMap, udpPortsMap) = portsMap {
	sprintf("%v", protocols[_]) == ["-1", "ALL"][_]
	portsMap = object.union(tcpPortsMap, udpPortsMap)
} else = portsMap {
	protocols[_] == "UDP"
	portsMap = udpPortsMap
} else = portsMap {
	protocols[_] == "TCP"
	portsMap = tcpPortsMap
}

CxPolicy[result] {
	#############	document and resource
	resources := input.document[i].Resources

	ec2InstanceList = [{"name": key, "properties": ec2Instance} |
		ec2Instance := resources[key]
		ec2Instance.Type == "AWS::EC2::Instance"
	]

	ec2Instance := ec2InstanceList[j]

	securityGroupList = [{"name": key, "properties": secGroup} |
		secGroup := resources[key]
		secGroup.Type == "AWS::EC2::SecurityGroup"
	]

	secGroup := securityGroupList[k]

	ec2Instance.properties.Properties.SecurityGroups[_] == secGroup.name

	ingress := secGroup.properties.Properties.SecurityGroupIngress[l]

	protocols := getProtocolList(ingress.IpProtocol)
	protocol := protocols[m]
	portsMap = getProtocolPorts(protocols, commonLib.tcpPortsMap, cf_lib.udpPortsMap)

	#############	Checks
	isAccessibleFromEntireNetwork(ingress)

	# is in ports range
	portRange := numbers.range(ingress.FromPort, ingress.ToPort)
	portsMap[portRange[idx]]
	portNumber = portRange[idx]
	portName := portsMap[portNumber]

	#############	Result
	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(secGroup.properties, secGroup.name),
		"searchKey": sprintf("Resources.%s.SecurityGroupIngress", [secGroup.name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in EC2 security group for instance %s", [portName, protocol, portNumber, ec2Instance.name]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in EC2 security group for instance %s", [portName, protocol, portNumber, ec2Instance.name]),
	}
}
