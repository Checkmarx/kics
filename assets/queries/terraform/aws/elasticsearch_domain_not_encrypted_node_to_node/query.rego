package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain[name]

	not common_lib.valid_key(resource, "node_to_node_encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'node_to_node_encryption' should be set to true",
		"keyActualValue": "The attribute 'node_to_node_encryption' is undefined",
		"remediation": "node_to_node_encryption {\n\t\t enabled = true \n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain[name].node_to_node_encryption

	not resource.enabled

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}].node_to_node_encryption.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name, "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The attribute 'node_to_node_encryption' should be set to true",
		"keyActualValue": "The attribute 'node_to_node_encryption' is not set to true",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
