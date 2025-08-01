package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EC2::Volume"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EC2::Volume"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.Encrypted)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted should be true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is false", [name]),
	}
}
