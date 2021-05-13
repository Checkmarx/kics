package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_workspaces_workspace[name]
	volumes := get_volumes(resource.workspace_properties)

	object.get(resource, volumes[n].key, "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_workspaces_workspace[{{%s}}].workspace_properties.%s", [name, volumes[n].value]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_workspaces_workspace.%s is set to true", [volumes[n].key]),
		"keyActualValue": sprintf("aws_workspaces_workspace.%s is missing", [volumes[n].key]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_workspaces_workspace[name]
	volumes := get_volumes(resource.workspace_properties)

	resource[volumes[n].key] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_workspaces_workspace[{{%s}}].%s", [name, volumes[n].key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_workspaces_workspace.%s is set to true", [volumes[n].key]),
		"keyActualValue": sprintf("aws_workspaces_workspace.%s is set to false", [volumes[n].key]),
	}
}

get_volumes(resource) = volumes {
	volume_size := {"user_volume_encryption_enabled": "user_volume_size_gib", "root_volume_encryption_enabled": "root_volume_size_gib"}
	volumes := {x | object.get(resource, volume_size[v], "undefined") != "undefined"; x := {"key": v, "value": volume_size[v]}}
}
