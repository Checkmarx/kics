package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	efs := input.document[i].resource.aws_ecs_task_definition[name].volume
	volume := efs.efs_volume_configuration
	not common_lib.valid_key(volume, "transit_encryption")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_task_definition[%s].volume.efs_volume_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration' is defined and not null",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration' is undefined or null",
		"searchLine": ["efs_volume_configuration"],
	}
}

CxPolicy[result] {
	efs := input.document[i].resource.aws_ecs_task_definition[name].volume
	volume := efs.efs_volume_configuration
	common_lib.valid_key(volume, "transit_encryption")
	volume.transit_encryption != "ENABLED"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_task_definition[%s].volume.efs_volume_configuration.transit_encryption", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption' is defined and not null",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption' is undefined or null",
		"searchLine": ["efs_volume_configuration"],
	}
}
