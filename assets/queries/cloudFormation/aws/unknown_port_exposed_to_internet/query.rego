package Cx

import data.generic.common as commonLib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	rule := resource.Properties.SecurityGroupIngress[index]

	entireNetwork(rule)
	containsUnknownPort(rule)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] shouldn't open unknown ports to the Internet", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] opens unknown ports to the Internet", [name, index]),
		"searchLine": commonLib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index], []),
	}
}

containsUnknownPort(rule) {
	not commonLib.valid_key(commonLib.tcpPortsMap, rule.FromPort)
} else {
	not commonLib.valid_key(commonLib.tcpPortsMap, rule.ToPort)
} else {
	some i
	port := numbers.range(rule.FromPort, rule.ToPort)[i]
	not commonLib.valid_key(commonLib.tcpPortsMap, port)
}

entireNetwork(rule) {
	rule.CidrIp == "0.0.0.0/0"
}

entireNetwork(rule) {
	rule.CidrIpv6 == "::/0"
}
