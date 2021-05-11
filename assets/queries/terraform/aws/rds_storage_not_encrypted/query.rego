package Cx

CxPolicy[result] {
	cluster := input.document[i].resource.aws_rds_cluster[name]

	not is_serverless(cluster)
	object.get(cluster, "storage_encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_rds_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_rds_cluster.storage_encrypted is set to true",
		"keyActualValue": "aws_rds_cluster.storage_encrypted is undefined",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_rds_cluster[name]

	cluster.storage_encrypted != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_rds_cluster[%s].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_rds_cluster.storage_encrypted is set to true",
		"keyActualValue": "aws_rds_cluster.storage_encrypted is set to false",
	}
}

is_serverless(cluster) {
	cluster.engine_mode == "serverless"
}
