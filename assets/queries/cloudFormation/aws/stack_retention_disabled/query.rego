package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	not common_lib.valid_key(resource.Properties, "AutoDeployment")

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

	common_lib.valid_key(resource.Properties, "AutoDeployment")

    autoDeployment := resource.Properties.AutoDeployment
	not common_lib.valid_key(autoDeployment, "Enabled")

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

    autoDeployment := resource.Properties.AutoDeployment

    autoDeployment.Enabled == false

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
	not common_lib.valid_key(autoDeployment, "RetainStacksOnAccountRemoval")

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

    autoDeployment.RetainStacksOnAccountRemoval == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is false", [name]),
	}
}

