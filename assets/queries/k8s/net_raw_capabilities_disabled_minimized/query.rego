package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	metadata := document.metadata
	spec := document.spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	capabilities := spec.containers[k].securityContext.capabilities
	not contains(capabilities.drop, ["ALL", "NET_RAW"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop", [metadata.name, types[x], containers[k].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop is ALL or NET_RAW", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop is not ALL or NET_RAW", [metadata.name, types[x], containers[k].name]),
	}
}

contains(array, elem) {
	upper(array[_]) == elem[_]
} else = false {
	true
}
