package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	rule := resource.Properties.SecurityGroupIngress[index]

	entireNetwork(rule)
	isTCP(rule.IpProtocol)
	rule.FromPort <= 80
	rule.ToPort >= 80

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] doesn't open the HTTP port (80)", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] opens the HTTP port (80)", [name, index]),
	}
}

entireNetwork(rule) {
	rule.CidrIp == "0.0.0.0/0"
}

entireNetwork(rule) {
	rule.CidrIpv6 == "::/0"
}

isTCP("tcp") = true

isTCP("-1") = true

isTCP("6") = true
