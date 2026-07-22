package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	vol_info := get_volumes(resource)[_]
	vol_info.volume.efs_volume_configuration.transit_encryption == "DISABLED"

	searchKey := get_search_key(name, vol_info.index, "volume", "efs_volume_configuration.transit_encryption")
	searchLine := get_search_line(name, vol_info.index, ["volume", "efs_volume_configuration", "transit_encryption"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": searchKey,
		"searchLine": searchLine,
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
	vol_info := get_volumes(resource)[_]
	enc := vol_info.volume.efs_volume_configuration
	not common_lib.valid_key(enc, "transit_encryption")

	searchKey := get_search_key(name, vol_info.index, "volume", "efs_volume_configuration")
	searchLine := get_search_line(name, vol_info.index, ["volume", "efs_volume_configuration"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": searchKey,
		"searchLine": searchLine,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption value should be 'ENABLED'",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration.transit_encryption is missing",
		"remediation": "transit_encryption = \"ENABLED\"",
		"remediationType": "addition",
	}
}

# Missing efs_volume_configuration only matters when the task may use host/EC2
# volumes that should be EFS-backed. Fargate tasks use platform-managed local
# storage for plain volume blocks, so requiring EFS transit encryption is an FP.
CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	not is_fargate_task(resource)
	vol_info := get_volumes(resource)[_]
	not common_lib.valid_key(vol_info.volume, "efs_volume_configuration")

	searchKey := get_search_key(name, vol_info.index, "volume", "")
	searchLine := get_search_line(name, vol_info.index, ["volume"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": searchKey,
		"searchLine": searchLine,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ecs_task_definition.volume.efs_volume_configuration value should be defined",
		"keyActualValue": "aws_ecs_task_definition.volume.efs_volume_configuration is not set",
	}
}

is_fargate_task(resource) {
	resource.requires_compatibilities[_] == "FARGATE"
}

get_volumes(resource) = volumes {
	is_array(resource.volume)
	volumes := [{"volume": vol, "index": idx} | vol := resource.volume[idx]]
} else = volumes {
	volumes := [{"volume": resource.volume, "index": null}]
}

get_search_key(name, index, base, suffix) = searchKey {
	index != null
	suffix != ""
	searchKey := sprintf("aws_ecs_task_definition[{{%s}}].%s[%d].%s", [name, base, index, suffix])
} else = searchKey {
	index != null
	suffix == ""
	searchKey := sprintf("aws_ecs_task_definition[{{%s}}].%s[%d]", [name, base, index])
} else = searchKey {
	index == null
	suffix != ""
	searchKey := sprintf("aws_ecs_task_definition[{{%s}}].%s.%s", [name, base, suffix])
} else = searchKey {
	index == null
	suffix == ""
	searchKey := sprintf("aws_ecs_task_definition[{{%s}}].%s", [name, base])
}

get_search_line(name, index, path_elements) = searchLine {
	index != null
	full_path := array.concat(["resource", "aws_ecs_task_definition", name], path_elements)
	path_with_index := array.concat(array.slice(full_path, 0, 4), array.concat([index], array.slice(full_path, 4, count(full_path))))
	searchLine := common_lib.build_search_line(path_with_index, [])
} else = searchLine {
	full_path := array.concat(["resource", "aws_ecs_task_definition", name], path_elements)
	searchLine := common_lib.build_search_line(full_path, [])
}
