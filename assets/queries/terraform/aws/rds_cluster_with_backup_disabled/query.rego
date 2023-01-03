package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_rds_cluster[name]
	not common_lib.valid_key(resource, "backup_retention_period")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_rds_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_rds_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_rds_cluster.backup_retention_period should be defined and not null",
		"keyActualValue": "aws_rds_cluster.backup_retention_period is undefined or null",
	}
}
