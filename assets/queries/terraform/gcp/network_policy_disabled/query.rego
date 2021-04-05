package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	not bothDefined(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'network_policy' is defined and Attribute 'addons_config' is defined",
		"keyActualValue": "Attribute 'network_policy' is undefined or Attribute 'addons_config' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	bothDefined(resource)
	not resource.addons_config.network_policy_config

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].addons_config", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'addons_config.network_policy_config' is defined",
		"keyActualValue": "Attribute 'addons_config.network_policy_config' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.network_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].network_policy", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'network_policy.enabled' is true",
		"keyActualValue": "Attribute 'network_policy.enabled' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.network_policy.enabled == true
	resource.addons_config.network_policy_config.disabled == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].addons_config.network_policy_config", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'addons_config.network_policy_config.disabled' is false",
		"keyActualValue": "Attribute 'addons_config.network_policy_config.disabled' is true",
	}
}

bothDefined(resource) {
	resource.network_policy
	resource.addons_config
}
