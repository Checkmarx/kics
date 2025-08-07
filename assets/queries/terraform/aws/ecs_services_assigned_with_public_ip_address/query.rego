package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_service[name]

	resource.network_configuration.assign_public_ip 

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_service[%s].network_configuration.assign_public_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_service[%s].network_configuration.assign_public_ip' should be set to 'false'(default value is 'false')", [name]),
		"keyActualValue": sprintf("'aws_ecs_service[%s].network_configuration.assign_public_ip' is set defined to true", [name]),
	}
}