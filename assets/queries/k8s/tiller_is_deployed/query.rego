package Cx

CxPolicy[result] {
	document := input.document[i]

	checkMetadata(document.metadata)
	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'metadata' does not refer any Tiller resource",
		"keyActualValue": "'metadata' refer to a Tiller resource",
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	contains(object.get(document.spec.containers[j], "image", "undefined"), "tiller")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.containers", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.containers' don't have any Tiller containers",
		"keyActualValue": "'spec.containers' contains a Tiller container",
	}
}

CxPolicy[result] {
	document := input.document[i]

	checkMetadata(document.spec.template.metadata)

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.metadata", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.template.metadata' does not refer any Tiller resource",
		"keyActualValue": "'spec.template.metadata' refer to a Tiller resource",
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	contains(object.get(document.spec.template.spec.containers[j], "image", "undefined"), "tiller")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.containers", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.template.spec.containers' don't have any Tiller containers",
		"keyActualValue": "'spec.template.spec.containers' contains a Tiller container",
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
