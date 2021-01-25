package Cx

create := "create"

pods := "pods"

CxPolicy[result] {
	document := input.document[i]
	rules := document.rules
	metadata := document.metadata

	isRoleKind(document.kind)
	rules[j].verbs[l] == create
	rules[j].resources[k] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.rules.verbs.%s", [metadata.name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain the value 'create' when metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains the value 'create' and metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	rules := document.rules
	metadata := document.metadata

	isRoleKind(document.kind)
	rules[j].verbs[l] == create
	isWildCardValue(rules[j].resources[k])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.rules.verbs.%s", [metadata.name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain the value 'create' when metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains the value 'create' and metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	rules := document.rules
	metadata := document.metadata

	isRoleKind(document.kind)
	isWildCardValue(rules[j].verbs[l])
	rules[j].resources[k] == pods

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.rules.verbs.%s", [metadata.name, rules[j].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	rules := document.rules
	metadata := document.metadata

	isRoleKind(document.kind)
	isWildCardValue(rules[j].verbs[l])
	isWildCardValue(rules[j].resources[k])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.rules.verbs.%s", [metadata.name, rules[j].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
	}
}

isWildCardValue(val) {
	regex.match(".*\\*.*", val)
}

isRoleKind("ClusterRole") = true

isRoleKind("Role") = true
