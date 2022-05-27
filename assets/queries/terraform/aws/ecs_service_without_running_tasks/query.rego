package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_service[name]

	not checkContent(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_service[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_service[%s]' has at least 1 task running'", [name]),
		"keyActualValue": sprintf("'aws_ecs_service[%s]' must have at least 1 task running", [name]),
	}
}

checkContent(deploymentConfiguration) {
	common_lib.valid_key(deploymentConfiguration, "deployment_maximum_percent")
}

checkContent(deploymentConfiguration) {
	common_lib.valid_key(deploymentConfiguration, "deployment_minimum_healthy_percent")
}
