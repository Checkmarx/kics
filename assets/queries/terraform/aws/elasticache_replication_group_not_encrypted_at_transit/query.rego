package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_replication_group[name]

	not common_lib.valid_key(resource, "transit_encryption_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_replication_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticache_replication_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'transit_encryption_enabled' should be set to true",
		"keyActualValue": "The attribute 'transit_encryption_enabled' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_replication_group[name]

	resource.transit_encryption_enabled != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_replication_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elasticache_replication_group[%s].transit_encryption_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The attribute 'transit_encryption_enabled' should be set to true",
		"keyActualValue": "The attribute 'transit_encryption_enabled' is not set to true",
	}
}
