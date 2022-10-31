package Cx

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
		"keyExpectedValue": sprintf("'metadata' of %s should not refer to any Tiller resource", [document.kind]),
		"keyActualValue": sprintf("'metadata' of %s refers to a Tiller resource", [document.kind]),
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
		"keyExpectedValue": sprintf("'spec.%s' of %s shouldn't have any Tiller containers", [types[x], document.kind]),
		"keyActualValue": sprintf("'spec.%s' of %s contains a Tiller container", [types[x], document.kind]),
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
		"keyExpectedValue": sprintf("'spec.template.metadata' should not refer to any Tiller resource", [document.kind]),
		"keyActualValue": sprintf("'spec.template.metadata' refers to a Tiller resource", [document.kind]),
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
		"keyExpectedValue": sprintf("'spec.template.spec.%s' of %s shouldn't have any Tiller containers", [types[x], document.kind]),
		"keyActualValue": sprintf("'spec.template.spec.%s' of %s contains a Tiller container", [types[x], document.kind]),
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
