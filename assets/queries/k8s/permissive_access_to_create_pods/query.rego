package Cx

import data.generic.k8s as k8s_lib
import data.generic.common as common_lib

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
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules.verbs.%s", [metadata.name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain the value 'create' when metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains the value 'create' and metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
		"searchLine": common_lib.build_search_line(["rules", j, "verbs"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	rules := document.rules
	metadata := document.metadata

	isRoleKind(document.kind)
	rules[j].verbs[l] == create
    notCustom(rules[j].apiGroups)
    isWildCardValue(rules[j].resources[k])
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules.verbs.%s", [metadata.name, create]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain the value 'create' when metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains the value 'create' and metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
		"searchLine": common_lib.build_search_line(["rules", j, "verbs"], []),
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
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules.verbs.%s", [metadata.name, rules[j].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains the value 'pods'", [metadata.name, metadata.name]),
	    "searchLine": common_lib.build_search_line(["rules", j, "verbs"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	rules := document.rules
	metadata := document.metadata

	isRoleKind(document.kind)
	isWildCardValue(rules[j].verbs[l])
	notCustom(rules[j].apiGroups)
	isWildCardValue(rules[j].resources[k])

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules.verbs.%s", [metadata.name, rules[j].verbs[l]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.rules.verbs should not contain a wildcard value when metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.rules.verbs contains a wildcard value and metadata.name=%s.rules.resources contains a wildcard value", [metadata.name, metadata.name]),
	    "searchLine": common_lib.build_search_line(["rules", j, "verbs"], []),
	}
}

isWildCardValue(val) {
	contains(val, "*")
}

isRoleKind(kind) {
    listKinds := ["ClusterRole", "Role"]
	k8s_lib.checkKind(kind, listKinds)
}

notCustom(apiGroups) {
    k8s := {"", "*"}
	apiGroups[z] == k8s[p]
}
