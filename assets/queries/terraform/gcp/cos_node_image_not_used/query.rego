package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]

	resource.node_config.image_type
	not startswith(lower(resource.node_config.image_type), "cos")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_node_pool[%s].node_config.image_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'node_config.image_type' should start with 'COS'",
		"keyActualValue": "'node_config.image_type' does not start with 'COS'",
	}
}
