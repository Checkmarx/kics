package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupEgress"

	properties := resource.Properties

	properties.IpProtocol == -1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.IpProtocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IpProtocol is not set to -1", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IpProtocol is set to -1", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupEgress[index].IpProtocol == -1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupEgress.IpProtocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].IpProtocol is not set to -1", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].IpProtocol is set to -1", [name, index]),
	}
}
