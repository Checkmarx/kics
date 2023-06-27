package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	efs_volume := resource.volume.efs_volume_configuration
	efs_volume.transit_encryption = "DISABLED"
	

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_task_definition[%s].volume.efs_volume_configuration.transit_encryption", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].volume.efs_volume_configuration.transit_encryption should be set to 'ENABLED'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].volume.efs_volume_configuration.transit_encryption is set to 'DISABLED'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system", name, "volume", "efs_volume_configuration", "transit_encryption"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	efs_volume := resource.volume.efs_volume_configuration
	not efs_volume.transit_encryption

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_task_definition[%s].volume.efs_volume_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].volume.efs_volume_configuration should be set to ENABLED", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].volume.efs_volume_configuration is not set", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system", name, "volume", "efs_volume_configuration"], []),
	}
}