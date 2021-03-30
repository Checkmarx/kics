package Cx

create := "create"

pods := "pods"

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	resource[name].rule[ru].verbs[l] == create
	resource[name].rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	resource[name].rule[ru].verbs[l] == create
	isWildCardValue(resource[name].rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	isWildCardValue(resource[name].rule[ru].verbs[l])
	resource[name].rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, resourceType.metadata.name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains the value 'pods'", [resourceType.metadata.name, resourceType.metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains the value 'pods'", [resourceType.metadata.name, resourceType.metadata.name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	isWildCardValue(resource[name].rule[ru].verbs[l])
	isWildCardValue(resource[name].rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain a wildcard value when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains a wildcard value and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	resource[name].rule.verbs[l] == create
	resource[name].rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	resource[name].rule.verbs[l] == create
	isWildCardValue(resource[name].rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	isWildCardValue(resource[name].rule.verbs[l])
	resource[name].rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, resource[name].rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	isWildCardValue(resource[name].rule.verbs[l])
	isWildCardValue(resource[name].rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].rule.verbs.%s", [resourceType, name, resource[name].rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain a wildcard value when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains a wildcard value and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

isWildCardValue(val) {
	regex.match(".*\\*.*", val)
}
