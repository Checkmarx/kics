package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]
	object.get(resource, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_docdb_cluster.kms_key_id is defined",
		"keyActualValue": "aws_docdb_cluster.kms_key_id is missing",
	}
}
