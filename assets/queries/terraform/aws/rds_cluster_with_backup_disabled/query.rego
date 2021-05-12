package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_rds_cluster[name]
	object.get(resource, "backup_retention_period", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_rds_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_rds_cluster.backup_retention_period is defined",
		"keyActualValue": "aws_rds_cluster.backup_retention_period is missing",
	}
}
