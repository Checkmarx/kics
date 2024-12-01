package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECR::Repository"

	not common_lib.valid_key(resource.Properties, "ImageTagMutability")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageTagMutability should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageTagMutability is undefined or null", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECR::Repository"

	resource.Properties.ImageTagMutability == "MUTABLE"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ImageTagMutability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageTagMutability should be 'IMMUTABLE'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageTagMutability is 'MUTABLE'", [name]),
	}
}
