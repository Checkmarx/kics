package Cx

CxPolicy[result] {
	resource := input.document[i].resource
	ecr_repo := resource.aws_ecr_repository[name]
	check_policy(resource, name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s] has policies attached", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s] doesn't have policies attached", [name]),
	}
}

check_policy(resource, name) {
	object.get(resource, "aws_ecr_repository_policy", "undefined") == "undefined"
} else {
	res_pol := {x | resource.aws_ecr_repository_policy[name_poly].repository == sprintf("${aws_ecr_repository.%s.name}", [name]); x := name_poly}
	count(res_pol) == 0
}
