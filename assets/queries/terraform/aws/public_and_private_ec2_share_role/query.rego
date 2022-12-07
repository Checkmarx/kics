package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	contains(resource.subnet_id, "public_subnets")

	instanceProfileName := split(resource.iam_instance_profile, ".")[1]

	check_private_instance(instanceProfileName, i)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s].iam_instance_profile", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Public and private instances should not share the same role",
		"keyActualValue": "Public and private instances share the same role",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "iam_instance_profile"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	subnetId := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "subnet_id")

	contains(module[subnetId], "public_subnets")

	iamInstanceProfile := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "iam_instance_profile")
	instanceProfileName := split(module[iamInstanceProfile], ".")[1]

	check_private_instance(instanceProfileName, i)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].iam_instance_profile", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Public and private instances should not share the same role",
		"keyActualValue": "Public and private instances share the same role",
		"searchLine": common_lib.build_search_line(["module", name, "iam_instance_profile"], []),
	}
}

check_private_instance(instanceProfileName, i) {
	instance := input.document[i].resource.aws_instance[name]

	contains(instance.subnet_id, "private_subnets")

	split(instance.iam_instance_profile, ".")[1] == instanceProfileName
} else {
	instance := input.document[i].module[name]
	subnetId := common_lib.get_module_equivalent_key("aws", instance.source, "aws_instance", "subnet_id")

	contains(instance[subnetId], "private_subnets")
	iamInstanceProfile := common_lib.get_module_equivalent_key("aws", instance.source, "aws_instance", "iam_instance_profile")

	split(instance[iamInstanceProfile], ".")[1] == instanceProfileName
}
