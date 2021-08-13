package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"

	not common_lib.valid_key(resource.Properties, "ImageTagMutability")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageTagMutability is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageTagMutability is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"

	resource.Properties.ImageTagMutability == "MUTABLE"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ImageTagMutability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageTagMutability is 'IMMUTABLE'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageTagMutability is 'MUTABLE'", [name]),
	}
}
