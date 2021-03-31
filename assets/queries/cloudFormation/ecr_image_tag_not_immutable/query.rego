package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"

	object.get(resource.Properties, "ImageTagMutability", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageTagMutability is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageTagMutability is undefined", [name]),
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
