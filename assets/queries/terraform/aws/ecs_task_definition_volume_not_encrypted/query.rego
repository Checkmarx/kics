package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	resource.volume.efs_volume_configuration.transit_encryption == "DISABLED"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_task_definition[{{%s}}].volume.efs_volume_configuration.transit_encryption", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value is 'ENABLED'",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value is 'DISABLED'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	enc := resource.volume.efs_volume_configuration
	object.get(enc, "transit_encryption", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_task_definition[{{%s}}].volume.efs_volume_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value is 'ENABLED'",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption is missing",
	}
}
