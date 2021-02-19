package Cx

CxPolicy[result] {
	efs := input.document[i].resource.aws_efs_file_system[name]
    object.get(efs,"encrypted","undefined") != "undefined"

    not efs.encrypted

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_efs_file_system[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].encrypted' is true", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].encrypted' is false", [name]),
	}
}

CxPolicy[result] {
	efs := input.document[i].resource.aws_efs_file_system[name]
    object.get(efs,"encrypted","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_efs_file_system[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_efs_file_system[%s].encrypted' is set", [name]),
		"keyActualValue": sprintf("aws_efs_file_system[%s].encrypted' is undefined", [name]),
	}
}
