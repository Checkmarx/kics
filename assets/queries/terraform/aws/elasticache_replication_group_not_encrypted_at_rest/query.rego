package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_elasticache_replication_group[name]

	not common_lib.valid_key(resource, "at_rest_encryption_enabled")

	result := {
		"documentId": document.id,
		"resourceType": "aws_elasticache_replication_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticache_replication_group[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_replication_group", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'at_rest_encryption_enabled' should be set to true",
		"keyActualValue": "The attribute 'at_rest_encryption_enabled' is undefined",
		"remediation": "at_rest_encryption_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_elasticache_replication_group[name]

	resource.at_rest_encryption_enabled != true

	result := {
		"documentId": document.id,
		"resourceType": "aws_elasticache_replication_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticache_replication_group[%s].at_rest_encryption_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_replication_group", name, "at_rest_encryption_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The attribute 'at_rest_encryption_enabled' should be set to true",
		"keyActualValue": "The attribute 'at_rest_encryption_enabled' is not set to true",
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
