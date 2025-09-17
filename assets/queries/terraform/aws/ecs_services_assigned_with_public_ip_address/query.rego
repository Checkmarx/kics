package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_service[name]

	resource.network_configuration.assign_public_ip == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_service[%s].network_configuration.assign_public_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_service[%s].network_configuration.assign_public_ip' should be set to 'false'(default value is 'false')", [name]),
		"keyActualValue": sprintf("'aws_ecs_service[%s].network_configuration.assign_public_ip' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ecs_service", name, "network_configuration", "assign_public_ip"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

    target_block := module[block]
	common_lib.get_module_equivalent_key("aws", module.source, "aws_ecs_service", block)

	target_block[service].assign_public_ip == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.%s.assign_public_ip",[name,block,service]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'module[%s].%s.%s.assign_public_ip' should be set to 'false'(default value is 'false')", [name,block,service]),
		"keyActualValue": sprintf("'module[%s].%s.%s.assign_public_ip' is set to true", [name,block,service]),
		"searchLine": common_lib.build_search_line(["module", name, block, service, "assign_public_ip"], []),
	}
}