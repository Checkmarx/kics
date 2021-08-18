package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_docdb_cluster.kms_key_id is defined and not null",
		"keyActualValue": "aws_docdb_cluster.kms_key_id is undefined or null",
	}
}
