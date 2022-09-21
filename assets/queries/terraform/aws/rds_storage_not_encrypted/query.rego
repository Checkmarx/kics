package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_rds_cluster[name]

	not is_serverless(cluster)
	not common_lib.valid_key(cluster, "storage_encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_rds_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("aws_rds_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_rds_cluster.storage_encrypted should be set to true",
		"keyActualValue": "aws_rds_cluster.storage_encrypted is undefined",
		"remediation": "storage_encrypted = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_rds_cluster[name]

	cluster.storage_encrypted != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_rds_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("aws_rds_cluster[%s].storage_encrypted", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster", name, "storage_encrypted"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_rds_cluster.storage_encrypted should be set to true",
		"keyActualValue": "aws_rds_cluster.storage_encrypted is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

is_serverless(cluster) {
	cluster.engine_mode == "serverless"
}
