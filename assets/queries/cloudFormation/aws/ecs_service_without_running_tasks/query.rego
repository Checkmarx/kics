package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	properties := resource.Properties

	not common_lib.valid_key(properties, "DeploymentConfiguration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DeploymentConfiguration is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DeploymentConfiguration is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	properties := resource.Properties

	not checkContent(properties.DeploymentConfiguration)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DeploymentConfiguration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DeploymentConfiguration has at least 1 task running", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DeploymentConfiguration must have at least 1 task running", [name]),
	}
}

checkContent(deploymentConfiguration) {
	common_lib.valid_key(deploymentConfiguration, "MaximumPercent")
}

checkContent(deploymentConfiguration) {
	common_lib.valid_key(deploymentConfiguration, "MinimumHealthyPercent")
}

checkContent(deploymentConfiguration) {
	common_lib.valid_key(deploymentConfiguration, "DeploymentCircuitBreaker")
}
