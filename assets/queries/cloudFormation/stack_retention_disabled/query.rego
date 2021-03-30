package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	object.get(resource.Properties, "AutoDeployment", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	object.get(resource.Properties, "AutoDeployment", "undefined") != "undefined"

    autoDeployment := resource.Properties.AutoDeployment
	object.get(autoDeployment, "Enabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	object.get(resource.Properties, "AutoDeployment", "undefined") != "undefined"

    autoDeployment := resource.Properties.AutoDeployment
	object.get(autoDeployment, "Enabled", "undefined") != "undefined"

    not autoDeployment.Enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"
    autoDeployment := resource.Properties.AutoDeployment

    autoDeployment.Enabled
	object.get(autoDeployment, "RetainStacksOnAccountRemoval", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"
    autoDeployment := resource.Properties.AutoDeployment

    autoDeployment.Enabled
	object.get(autoDeployment, "RetainStacksOnAccountRemoval", "undefined") != "undefined"

    not autoDeployment.RetainStacksOnAccountRemoval

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is false", [name]),
	}
}

