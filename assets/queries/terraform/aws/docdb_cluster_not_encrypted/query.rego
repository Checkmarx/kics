package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]
	object.get(resource, "storage_encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_docdb_cluster.storage_encrypted is set to true",
		"keyActualValue": "aws_docdb_cluster.storage_encrypted is missing",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]
	resource.storage_encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_docdb_cluster.storage_encrypted is set to true",
		"keyActualValue": "aws_docdb_cluster.storage_encrypted is set to false",
	}
}
