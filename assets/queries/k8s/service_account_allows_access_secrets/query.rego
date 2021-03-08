package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	validKind := ["Role", "ClusterRole"]
	ruleTaint := ["get", "watch", "list", "*"]
	resourcesTaint := ["secrets"]

	kind := document.kind
	contains(validKind, kind)
	name := metadata.name

	bindingExists(name, kind)

	some resource
	resources := document.rules[resource].resources
	resources[_] == "secrets"

	rules := document.rules[resource].verbs
	some rule
	contains(ruleTaint, rules[rule])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The metadata.name=%s.rules.verbs should not contain the following verbs: [%s]", [metadata.name, rules]),
		"keyActualValue": sprintf("The metadata.name=%s.rules.verbs contain the following verbs: [%s]", [metadata.name, rules]),
	}
}

contains(arr1, string) {
	arr1[_] == string
}

bindingExists(name, kind) {
	kind == "Role"

	some roleBinding
	input.document[roleBinding].kind == "RoleBinding"
	input.document[roleBinding].subjects[_].kind == "ServiceAccount"
	input.document[roleBinding].roleRef.kind == "Role"
	input.document[roleBinding].roleRef.name == name
} else {
	kind == "ClusterRole"

	some roleBinding
	input.document[roleBinding].kind == "ClusterRoleBinding"
	input.document[roleBinding].subjects[_].kind == "ServiceAccount"
	input.document[roleBinding].roleRef.kind == "ClusterRole"
	input.document[roleBinding].roleRef.name == name
}
