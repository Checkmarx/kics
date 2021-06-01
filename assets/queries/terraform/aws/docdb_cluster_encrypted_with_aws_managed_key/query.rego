package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]

	terraLib.uses_aws_managed_key(resource.kms_key_id, "alias/aws/rds")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_docdb_cluster[%s].kms_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "DOCDB Cluster is not encrypted with AWS managed key",
		"keyActualValue": "DOCDB Cluster is encrypted with AWS managed key",
	}
}
