package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	container.securityContext.allowPrivilegeEscalation == true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation should be set to false", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation is true", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "securityContext", "allowPrivilegeEscalation"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	containerCtx := object.get(container, "securityContext", {})
	not common_lib.valid_key(containerCtx, "allowPrivilegeEscalation")

	dynamic_path := k8sLib.get_valid_search_line_path(container, ["securityContext"])
	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation should be set and should be set to false", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation is undefined", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), array.concat([types[x], c], dynamic_path.searchLine))
	}
}
