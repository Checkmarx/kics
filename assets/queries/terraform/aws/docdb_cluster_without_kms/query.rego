package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_docdb_cluster[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": document.id,
		"resourceType": "aws_docdb_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_docdb_cluster.kms_key_id should be defined and not null",
		"keyActualValue": "aws_docdb_cluster.kms_key_id is undefined or null",
	}
}
