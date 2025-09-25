package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Batch::JobDefinition"
	properties := resource.Properties
	cf_lib.isCloudFormationTrue(properties.ContainerProperties.Privileged)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ContainerProperties.Privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ContainerProperties.Privileged should be set to false", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ContainerProperties.Privileged is true", [name]),
	}
}
