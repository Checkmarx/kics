package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	resource.server_side_encryption.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dax_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dax_cluster[{{%s}}].server_side_encryption.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_dax_cluster", name,"server_side_encryption","enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled should be set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption.enabled is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	not common_lib.valid_key(resource, "server_side_encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dax_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dax_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled should be set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption is missing",
		"remediation": "server_side_encryption {\n\t\tenabled = true\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_dax_cluster[name]
	common_lib.valid_key(resource, "server_side_encryption")
	not common_lib.valid_key(resource.server_side_encryption, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dax_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dax_cluster[{{%s}}].server_side_encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dax_cluster.server_side_encryption.enabled should be set to true",
		"keyActualValue": "aws_dax_cluster.server_side_encryption.enabled is missing",
		"remediation": "enabled = true",
		"remediationType": "addition",
	}
}
