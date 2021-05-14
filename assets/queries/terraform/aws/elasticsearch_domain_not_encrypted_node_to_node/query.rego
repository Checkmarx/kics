package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain[name]

	object.get(resource, "node_to_node_encryption", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'node_to_node_encryption' is set to true",
		"keyActualValue": "The attribute 'node_to_node_encryption' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticsearch_domain[name].node_to_node_encryption

	not resource.enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticsearch_domain[{{%s}}].node_to_node_encryption.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The attribute 'node_to_node_encryption' is set to true",
		"keyActualValue": "The attribute 'node_to_node_encryption' is not set to true",
	}
}
