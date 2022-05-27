package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	ecr_repo := resource.aws_ecr_repository[name]
	check_policy(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecr_repository",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s] has policies attached", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s] doesn't have policies attached", [name]),
	}
}

check_policy(resource, name) {
	not common_lib.valid_key(resource, "aws_ecr_repository_policy")
} else {
	res_pol := {x | resource.aws_ecr_repository_policy[name_poly].repository == sprintf("${aws_ecr_repository.%s.name}", [name]); x := name_poly}
	count(res_pol) == 0
}
