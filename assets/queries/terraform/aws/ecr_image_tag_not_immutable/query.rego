package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	not common_lib.valid_key(resource, "image_tag_mutability")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository.%s.image_tag_mutability is defined and not null", [name]),
		"keyActualValue": sprintf("aws_ecr_repository.%s.image_tag_mutability is undefined or null", [name]),
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
