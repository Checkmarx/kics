package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	not common_lib.valid_key(resource.Properties, "AutoDeployment")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment is undefined", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	common_lib.valid_key(resource.Properties, "AutoDeployment")

	autoDeployment := resource.Properties.AutoDeployment
	not common_lib.valid_key(autoDeployment, "Enabled")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is undefined", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"

	autoDeployment := resource.Properties.AutoDeployment

	autoDeployment.Enabled == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.Enabled is false", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"
	autoDeployment := resource.Properties.AutoDeployment

	autoDeployment.Enabled
	not common_lib.valid_key(autoDeployment, "RetainStacksOnAccountRemoval")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is undefined", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFormation::StackSet"
	autoDeployment := resource.Properties.AutoDeployment

	autoDeployment.Enabled

	autoDeployment.RetainStacksOnAccountRemoval == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AutoDeployment.RetainStacksOnAccountRemoval is false", [name]),
	}
}
