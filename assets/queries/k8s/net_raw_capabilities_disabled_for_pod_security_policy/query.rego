package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	metadata := document.metadata
	spec := document.spec
	not contains(spec.requiredDropCapabilities, ["ALL", "NET_RAW"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.requiredDropCapabilities", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.requiredDropCapabilities 'is ALL or NET_RAW'",
		"keyActualValue": "spec.requiredDropCapabilities 'is not ALL or NET_RAW'",
	}
}

contains(array, elem) {
	upper(array[_]) == elem[_]
} else = false {
	true
}
