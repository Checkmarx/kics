package Cx

import data.generic.cloudformation as cloudFormationLib
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
	protocols[_] == ["-1", "ALL"][_]
	portsMap = object.union(tcpPortsMap, udpPortsMap)
} else = portsMap {
	protocols[_] == "UDP"
	portsMap = udpPortsMap
} else = portsMap {
	protocols[_] == "TCP"
	portsMap = tcpPortsMap
}

getELBType(elb) = type {
	object.get(elb.Properties, "Type", "unspecified") != "unspecified"
	type = elb.Properties.Type
} else = type {
	elb.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	type = "classic"
} else = type {
	elb.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
	type = "application"
}

getLinkedSecGroupList(elb, resources) = elbSecGroupName {
	object.get(elb.Properties, "SecurityGroups", "unspecified") != "unspecified"
	elbSecGroupName = elb.Properties.SecurityGroups
} else = ec2SecGroup {
	ec2InstanceList := [ec2 | ec2 := resources[name]; contains(upper(ec2.Type), "INSTANCE")]
	ec2Instance := ec2InstanceList[i]
	object.get(ec2Instance.Properties, "SecurityGroups", "unspecified") != "unspecified"
	ec2SecGroup = ec2Instance.Properties.SecurityGroups
}

CxPolicy[result] {
	#############	document and resource
	resources := input.document[i].Resources
	loadBalancerList := [{"name": key, "properties": loadBalancer} |
		loadBalancer := resources[key]
		contains(loadBalancer.Type, "ElasticLoadBalancing")
	]

	elb := loadBalancerList[j]
	elbType := getELBType(elb.properties)
	elbSecGroupList := getLinkedSecGroupList(elb.properties, resources)

	securityGroupList = [{"name": key, "properties": secGroup} |
		secGroup := resources[key]
		contains(secGroup.Type, "SecurityGroup")
	]

	secGroup := securityGroupList[k]
	secGroup.name == elbSecGroupList[l]
	ingress := secGroup.properties.Properties.SecurityGroupIngress[m]

	protocols := getProtocolList(ingress.IpProtocol)
	protocol := protocols[n]
	portsMap = getProtocolPorts(protocols, commonLib.tcpPortsMap, cloudFormationLib.udpPortsMap)

	#############	Checks
	isAccessibleFromEntireNetwork(ingress)

	# is in ports range
	portRange := numbers.range(ingress.FromPort, ingress.ToPort)
	portsMap[portRange[idx]]
	portNumber = portRange[idx]
	portName := portsMap[portNumber]

	##############	Result
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.SecurityGroupIngress", [secGroup.name]),
		"searchValue": sprintf("%s,%d", [protocol, portNumber]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s (%s:%d) should not be allowed in %s load balancer %s", [portName, protocol, portNumber, elbType, elb.name]),
		"keyActualValue": sprintf("%s (%s:%d) is allowed in %v load balancer %s", [portName, protocol, portNumber, elbType, elb.name]),
	}
}
