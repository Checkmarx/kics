package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	object.get(resource, "image_tag_mutability", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository.%s.image_tag_mutability is defined", [name]),
		"keyActualValue": sprintf("aws_ecr_repository.%s.image_tag_mutability is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	resource.image_tag_mutability == "MUTABLE"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository.%s.image_tag_mutability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_ecr_repository.%s.image_tag_mutability is 'IMMUTABLE'", [name]),
		"keyActualValue": sprintf("aws_ecr_repository.%s.image_tag_mutability is 'MUTABLE'", [name]),
	}
}
