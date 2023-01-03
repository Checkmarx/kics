package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	rds := input.document[i].resource.aws_db_cluster_snapshot[name]
	db := rds.db_cluster_identifier
	dbName := split(db, ".")[1]

	not rds_cluster_encrypted(dbName)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_cluster_snapshot",
		"resourceName": tf_lib.get_resource_name(rds, name),
		"searchKey": sprintf("aws_db_cluster_snapshot[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_db_cluster_snapshot.db_cluster_identifier' should be encrypted",
		"keyActualValue": "aws_db_cluster_snapshot.db_cluster_identifier' is not encrypted",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_cluster_snapshot", name], []),
	}
}

rds_cluster_encrypted(rdsName) {
	rds := input.document[i].resource.aws_rds_cluster[rdsName]
	rds.storage_encrypted == true
}
