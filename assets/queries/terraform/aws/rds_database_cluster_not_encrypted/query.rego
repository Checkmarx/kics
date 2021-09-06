package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	rds := input.document[i].resource.aws_db_cluster_snapshot[name]
	not common_lib.valid_key(rds, "storage_encrypted")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_cluster_snapshot[%s].storage_encrypted", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_db_cluster_snapshot.storage_encrypted' is defined and not null",
		"keyActualValue": "aws_db_cluster_snapshot.storage_encrypted' is undefined or null",
		"searchLine": ["storage_encrypted"],
	}
}

CxPolicy[result] {
	rds := input.document[i].resource.aws_db_cluster_snapshot[name]
	common_lib.valid_key(rds, "storage_encrypted")
	rds.storage_encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_cluster_snapshot[%s].storage_encrypted", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_db_cluster_snapshot.storage_encrypted' is defined and not null",
		"keyActualValue": "aws_db_cluster_snapshot.storage_encrypted' is undefined or null",
		"searchLine": ["storage_encrypted"],
	}
}
