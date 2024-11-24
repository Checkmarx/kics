package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	rds := document.resource.aws_db_cluster_snapshot[name]
	db := rds.db_cluster_identifier
	dbName := split(db, ".")[1]

	not rds_cluster_encrypted(dbName)

	result := {
		"documentId": document.id,
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
	some document in input.document
	rds := document.resource.aws_rds_cluster[rdsName]
	rds.storage_encrypted == true
}
