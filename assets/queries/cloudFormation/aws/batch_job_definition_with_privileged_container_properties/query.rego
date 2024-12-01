package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource = doc.Resources[name]
	resource.Type == "AWS::Batch::JobDefinition"
	properties := resource.Properties
	properties.ContainerProperties.Privileged == true

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ContainerProperties.Privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ContainerProperties.Privileged should be set to false", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ContainerProperties.Privileged is true", [name]),
	}
}
