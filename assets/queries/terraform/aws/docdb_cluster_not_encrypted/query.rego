package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]
	not common_lib.valid_key(resource, "storage_encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_docdb_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
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
		"resourceType": "aws_docdb_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_docdb_cluster.storage_encrypted is set to true",
		"keyActualValue": "aws_docdb_cluster.storage_encrypted is set to false",
	}
}
