package Cx

create := "create"

pods := "pods"

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	resource.rule[ru].verbs[l] == create
	resource.rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	resource.rule[ru].verbs[l] == create
	isWildCardValue(resource.rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	isWildCardValue(resource.rule[ru].verbs[l])
	resource.rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	isWildCardValue(resource.rule[ru].verbs[l])
	isWildCardValue(resource.rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain a wildcard value when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains a wildcard value and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]

	resource.rule.verbs[l] == create
	resource.rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	resource.rule.verbs[l] == create
	isWildCardValue(resource.rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain the value 'create' when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains the value 'create' and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	isWildCardValue(resource.rule.verbs[l])
	resource.rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, resource.rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role[name]
	isWildCardValue(resource.rule.verbs[l])
	isWildCardValue(resource.rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_role[%s].rule.verbs.%s", [name, resource.rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_role[%s].rule.verbs should not contain a wildcard value when kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_role[%s].rule.verbs contains a wildcard value and kubernetes_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	resource.rule[ru].verbs[l] == create
	resource.rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain the value 'create' when kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains the value 'create' and kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	resource.rule[ru].verbs[l] == create
	isWildCardValue(resource.rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain the value 'create' when kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains the value 'create' and kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	isWildCardValue(resource.rule[ru].verbs[l])
	resource.rule[ru].resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain a wildcard value when kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains a wildcard value and kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	isWildCardValue(resource.rule[ru].verbs[l])
	isWildCardValue(resource.rule[ru].resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, resource.rule[ru].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain a wildcard value when kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains a wildcard value and kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	resource.rule.verbs[l] == create
	resource.rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain the value 'create' when kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains the value 'create' and kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	resource.rule.verbs[l] == create
	isWildCardValue(resource.rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain the value 'create' when kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains the value 'create' and kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	isWildCardValue(resource.rule.verbs[l])
	resource.rule.resources[r] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, resource.rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain a wildcard value when kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains a wildcard value and kubernetes_cluster_role[%s].rule.resources contains the value 'pods'", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role[name]
	isWildCardValue(resource.rule.verbs[l])
	isWildCardValue(resource.rule.resources[r])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cluster_role[%s].rule.verbs.%s", [name, resource.rule.verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cluster_role[%s].rule.verbs should not contain a wildcard value when kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
		"keyActualValue": sprintf("kubernetes_cluster_role[%s].rule.verbs contains a wildcard value and kubernetes_cluster_role[%s].rule.resources contains a wildcard value", [name, name]),
	}
}

isWildCardValue(val) {
	regex.match(".*\\*.*", val)
}
