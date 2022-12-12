package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_workspaces_workspace[name]
	volumes := get_volumes(resource.workspace_properties)
	volumesKey := volumes[n].key

	not common_lib.valid_key(resource, volumesKey)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_workspaces_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_workspaces_workspace[{{%s}}].workspace_properties.%s", [name, volumes[n].value]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_workspaces_workspace.%s should be set to true", [volumesKey]),
		"keyActualValue": sprintf("aws_workspaces_workspace.%s is missing", [volumesKey]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_workspaces_workspace[name]
	volumes := get_volumes(resource.workspace_properties)

	resource[volumes[n].key] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_workspaces_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_workspaces_workspace[{{%s}}].%s", [name, volumes[n].key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_workspaces_workspace.%s should be set to true", [volumes[n].key]),
		"keyActualValue": sprintf("aws_workspaces_workspace.%s is set to false", [volumes[n].key]),
	}
}

get_volumes(resource) = volumes {
	volume_size := {"user_volume_encryption_enabled": "user_volume_size_gib", "root_volume_encryption_enabled": "root_volume_size_gib"}
	volumes := {x | common_lib.valid_key(resource, volume_size[v]); x := {"key": v, "value": volume_size[v]}}
}
