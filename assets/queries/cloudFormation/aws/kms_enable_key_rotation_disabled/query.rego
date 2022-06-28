package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::KMS::Key"
	keyRotation := resources.Properties.EnableKeyRotation
	keyRotation == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.EnableKeyRotation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EnableKeyRotation is not 'true'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EnableKeyRotation is true", [name]),
	}
}

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::KMS::Key"
	properties := resources.Properties
	not common_lib.valid_key(properties, "EnableKeyRotation")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.EnableKeyRotation", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EnableKeyRotation is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EnableKeyRotation is undefined", [name]),
	}
}
