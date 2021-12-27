package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	rule := resource.Properties.SecurityGroupIngress[index]

	entireNetwork(rule)
	isTCP(rule.IpProtocol)
	rule.FromPort <= 3389
	rule.ToPort >= 3389

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] doesn't open the remote desktop port (3389)", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] opens the remote desktop port (3389)", [name, index]),
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
