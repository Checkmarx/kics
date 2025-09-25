package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo = k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	drop := container.securityContext.capabilities.drop
	not common_lib.compareArrays(drop, ["ALL", "NET_RAW"])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.drop", [metadata.name, specInfo.path, types[x], container.name]),
		"searchValue": document.kind,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.drop includes ALL or NET_RAW", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.drop does not include ALL or NET_RAW", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x],c,"securityContext", "capabilities", "drop"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo = k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	containerCtx := object.get(container, "securityContext", {})
	containerCapabilitiesCtx := object.get(containerCtx, "capabilities", {})
	not common_lib.valid_key(containerCapabilitiesCtx, "drop")

    dynamic_path := k8sLib.get_valid_search_line_path(container,["securityContext", "capabilities"])
	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind,
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.drop should be defined", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.drop is undefined", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), array.concat([types[x], c], dynamic_path.searchLine)),
	}
}
