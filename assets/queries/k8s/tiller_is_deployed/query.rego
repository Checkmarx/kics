package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]

	k8sLib.checkMetadata(document.metadata)
	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'metadata' does not refer any to a Tiller resource",
		"keyActualValue": "'metadata' refers to a Tiller resource",
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	types := {"initContainers", "containers"}
	contains(object.get(document.spec[types[x]][j], "image", "undefined"), "tiller")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s", [metadata.name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.containers' doesn't have any Tiller containers", [types[x]]),
		"keyActualValue": sprintf("'spec.containers' contains a Tiller container", [types[x]]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	k8sLib.checkMetadata(document.spec.template.metadata)

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.metadata", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.template.metadata' does not refer to any Tiller resource",
		"keyActualValue": "'spec.template.metadata' refers to a Tiller resource",
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	types := {"initContainers", "containers"}
	contains(object.get(document.spec.template.spec[types[x]][j], "image", "undefined"), "tiller")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.%s", [metadata.name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.%s' doesn't have any Tiller containers", [types[x]]),
		"keyActualValue": sprintf("'spec.template.spec.%s' contains a Tiller container", [types[x]]),
	}
}
