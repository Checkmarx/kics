package Cx

CxPolicy[result] {
	document := input.document[i]

	some j
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][j]
	object.get(container, "securityContext", "undefined") == "undefined"

	metadata := document.metadata
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.%s[%d].securityContext' is set", [types[x], j]),
		"keyActualValue": sprintf("'spec.%s[%d].securityContext' is undefined", [types[x], j]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][j]
	securityContext := container.securityContext
	object.get(securityContext, "readOnlyRootFilesystem", "undefined") == "undefined"

	metadata := document.metadata
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.%s[%d].securityContext.readOnlyRootFilesystem' is set and is true", [types[x], j]),
		"keyActualValue": sprintf("'spec.%s[%d].securityContext.readOnlyRootFilesystem' is undefined", [types[x], j]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	some j
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][j]
	container.securityContext.readOnlyRootFilesystem == false

	metadata := document.metadata
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.readOnlyRootFilesystem", [metadata.name, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.containe%ss[%d].securityContext.readOnlyRootFilesystem' is true", [types[x], j]),
		"keyActualValue": sprintf("'spec.%s[%d].securityContext.readOnlyRootFilesystem' is false", [types[x], j]),
	}
}
