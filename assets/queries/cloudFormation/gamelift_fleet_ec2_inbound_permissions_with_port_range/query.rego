package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::GameLift::Fleet"

	properties := resource.Properties

	is_string(properties.EC2InboundPermissions[index].FromPort)
    is_string(properties.EC2InboundPermissions[index].ToPort)
    properties.EC2InboundPermissions[index].FromPort != properties.EC2InboundPermissions[index].ToPort

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EC2InboundPermissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is not equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::GameLift::Fleet"

	properties := resource.Properties

	is_number(properties.EC2InboundPermissions[index].FromPort)
    is_number(properties.EC2InboundPermissions[index].ToPort)
    properties.EC2InboundPermissions[index].FromPort != properties.EC2InboundPermissions[index].ToPort

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EC2InboundPermissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is not equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::GameLift::Fleet"

	properties := resource.Properties

	is_string(properties.EC2InboundPermissions[index].FromPort)
    is_number(properties.EC2InboundPermissions[index].ToPort)
    to_number(properties.EC2InboundPermissions[index].FromPort) != properties.EC2InboundPermissions[index].ToPort

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EC2InboundPermissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is not equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::GameLift::Fleet"

	properties := resource.Properties

	is_number(properties.EC2InboundPermissions[index].FromPort)
    is_string(properties.EC2InboundPermissions[index].ToPort)
    properties.EC2InboundPermissions[index].FromPort != to_number(properties.EC2InboundPermissions[index].ToPort)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EC2InboundPermissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.EC2InboundPermissions[%d].FromPort is not equal to Resources.%s.Properties.EC2InboundPermissions[%d].ToPort", [name, index, name, index]),
	}
}