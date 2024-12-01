package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_rds_cluster[name]
	resource.storage_encrypted == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_rds_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_rds_cluster[{{%s}}].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_rds_cluster.storage_encrypted should be set to 'true'",
		"keyActualValue": "aws_rds_cluster.storage_encrypted is set to 'false'",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_rds_cluster[name]
	not common_lib.valid_key(resource, "storage_encrypted")

	result := {
		"documentId": document.id,
		"resourceType": "aws_rds_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_rds_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_rds_cluster.storage_encrypted should be defined and set to 'true'",
		"keyActualValue": "aws_rds_cluster.storage_encrypted is undefined",
	}
}
