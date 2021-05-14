package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	object.get(resource, "server_side_encryption", "undefined") != "undefined"
	object.get(resource.server_side_encryption, "enabled", "undefined") != "undefined"
	not resource.server_side_encryption.enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dax_cluster[{{%s}}].server_side_encryption.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled is set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption.enabled is set to false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	object.get(resource, "server_side_encryption", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dax_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled is set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption is missing",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	object.get(resource.server_side_encryption, "enabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dax_cluster[{{%s}}].server_side_encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled is set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption.enabled is missing",
	}
}
