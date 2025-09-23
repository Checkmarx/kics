package Cx

import data.generic.k8s as k8sLib
import data.generic.common as commonLib


CxPolicy[result] {
	document := input.document[i]

	checkMetadata(document.metadata)
	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same rule
		"keyExpectedValue": sprintf("'metadata' of %s should not refer to any Tiller resource", [document.kind]),
		"keyActualValue": sprintf("'metadata' of %s refers to a Tiller resource", [document.kind]),
		"searchLine": commonLib.build_search_line(["metadata"],[]),
	}
}

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]

	some j
	contains(object.get(document.spec[types[x]][j], "image", "undefined"), "tiller")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s", [metadata.name, types[x]]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same rule
		"keyExpectedValue": sprintf("'spec.%s' of %s shouldn't have any Tiller containers", [types[x], document.kind]),
		"keyActualValue": sprintf("'spec.%s' of %s contains a Tiller container", [types[x], document.kind]),
		"searchLine": commonLib.build_search_line(["spec", types[x]],[]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	checkMetadata(document.spec.template.metadata)

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.metadata", [metadata.name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("'spec.template.metadata' should not refer to any Tiller resource", [document.kind]),
		"keyActualValue": sprintf("'spec.template.metadata' refers to a Tiller resource", [document.kind]),
		"searchLine": commonLib.build_search_line(["spec", "template", "metadata"],[]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	contains(object.get(document.spec.template.spec[types[x]][j], "image", "undefined"), "tiller")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.%s", [metadata.name, types[x]]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("'spec.template.spec.%s' of %s shouldn't have any Tiller containers", [types[x], document.kind]),
		"keyActualValue": sprintf("'spec.template.spec.%s' of %s contains a Tiller container", [types[x], document.kind]),
		"searchLine": commonLib.build_search_line(["spec", "template", "spec", types[x] ],[]),
	}
}

checkMetadata(metadata) {
	contains(metadata.name, "tiller")
}

checkMetadata(metadata) {
	object.get(metadata.labels, "app", "undefined") == "helm"
}

checkMetadata(metadata) {
	contains(object.get(metadata.labels, "name", "undefined"), "tiller")
}
