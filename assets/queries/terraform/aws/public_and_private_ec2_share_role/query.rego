package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	contains(resource.subnet_id, "public_subnets")

	instanceProfileName := split(resource.iam_instance_profile, ".")[1]

	check_private_instance(instanceProfileName)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[%s].iam_instance_profile", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Public and private istances do not share the same role",
		"keyActualValue": "Public and private istances share the same role",
	}
}

check_private_instance(instanceProfileName) {
	instance := input.document[z].resource.aws_instance[name]

	contains(instance.subnet_id, "private_subnets")

	split(instance.iam_instance_profile, ".")[1] == instanceProfileName
}
