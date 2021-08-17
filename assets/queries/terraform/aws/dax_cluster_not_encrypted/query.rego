package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	resource.server_side_encryption.enabled == false

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
	not common_lib.valid_key(resource, "server_side_encryption")

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
	not common_lib.valid_key(resource.server_side_encryption, "enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_dax_cluster[{{%s}}].server_side_encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled is set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption.enabled is missing",
	}
}
