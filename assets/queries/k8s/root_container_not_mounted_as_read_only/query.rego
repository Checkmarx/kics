package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

types := {"initContainers", "containers"}

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	container.securityContext.readOnlyRootFilesystem == false

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.readOnlyRootFilesystem", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.readOnlyRootFilesystem is true", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.readOnlyRootFilesystem is false", [metadata.name, specInfo.path, types[x], container.name]),
	}
}

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	containerCtx := object.get(container, "securityContext", {})
	not common_lib.valid_key(containerCtx, "readOnlyRootFilesystem")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.readOnlyRootFilesystem should be set to true", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.readOnlyRootFilesystem is undefined", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "securityContext"]),
	}
}
