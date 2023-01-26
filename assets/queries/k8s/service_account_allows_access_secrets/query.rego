package Cx

import data.generic.k8s as k8sLib
import data.generic.common as commonLib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	validKind := ["Role", "ClusterRole"]
	ruleTaint := ["get", "watch", "list", "*"]

	kind := document.kind
	k8sLib.checkKind(kind, validKind)
	name := metadata.name

	bindingExists(name, kind)

	some resource
	resources := document.rules[resource].resources
	resources[_] == "secrets"

	rules := document.rules[resource].verbs
	commonLib.compareArrays(ruleTaint, rules)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The metadata.name={{%s}}.rules.verbs should not contain the following verbs: [%s]", [metadata.name, rules]),
		"keyActualValue": sprintf("The metadata.name={{%s}}.rules.verbs contain the following verbs: [%s]", [metadata.name, rules]),
		"searchLine": commonLib.build_search_line(["rules", resource, "verbs"],[]),
	}
}

bindingExists(name, kind) {
	kind == "Role"

	input.document[roleBinding].kind == "RoleBinding"
	input.document[roleBinding].subjects[_].kind == "ServiceAccount"
	input.document[roleBinding].roleRef.kind == "Role"
	input.document[roleBinding].roleRef.name == name
} else {
	kind == "ClusterRole"

	input.document[roleBinding].kind == "ClusterRoleBinding"
	input.document[roleBinding].subjects[_].kind == "ServiceAccount"
	input.document[roleBinding].roleRef.kind == "ClusterRole"
	input.document[roleBinding].roleRef.name == name
}
