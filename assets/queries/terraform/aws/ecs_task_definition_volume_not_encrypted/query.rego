package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	resource.volume.efs_volume_configuration.transit_encryption == "DISABLED"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_task_definition[{{%s}}].volume.efs_volume_configuration.transit_encryption", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ecs_task_definition", name, "volume", "efs_volume_configuration", "transit_encryption"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value should be 'ENABLED'",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value is 'DISABLED'",
		"remediation": json.marshal({
			"before": "DISABLED",
			"after": "ENABLED"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	enc := resource.volume.efs_volume_configuration
	not common_lib.valid_key(enc, "transit_encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_task_definition[{{%s}}].volume.efs_volume_configuration", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ecs_task_definition", name, "volume", "efs_volume_configuration"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value should be 'ENABLED'",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption is missing",
		"remediation": "transit_encryption = \"ENABLED\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	volume := resource.volume
	not common_lib.valid_key(volume, "efs_volume_configuration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_task_definition[{{%s}}].volume", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ecs_task_definition", name, "volume"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration value should be defined",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration is not set",
	}
}