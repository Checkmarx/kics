package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

# container defines runAsUser
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	uid := specInfo.spec[types[x]][c].securityContext.runAsUser
	to_number(uid) < 10000

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser=%d", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name, uid]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("1 metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser should be set to a UID >= 10000", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is set to a low UID", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "securityContext", "runAsUser"]),
	}
}

# pod defines runAsUser and container inherits this setting
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

    # check if none of the containers has runAsUser defined
	nested_info := common_lib.get_nested_values_info(specInfo.spec[types[x]][_], ["securityContext", "runAsUser"])
	nested_info.valid == false

	uid := specInfo.spec.securityContext.runAsUser
	to_number(uid) < 10000

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser=%d", [metadata.name, specInfo.path, uid]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("2 metadata.name={{%s}}.%s.securityContext.runAsUser should be set to a UID >= 10000", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is set to a low UID", [metadata.name, specInfo.path]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["securityContext", "runAsUser"]),
	}
}

# neither pod nor container define runAsUser
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	nested_info := common_lib.get_nested_values_info(specInfo.spec, ["securityContext", "runAsUser"])
	nested_info.valid == false

	nested_info2 := common_lib.get_nested_values_info(specInfo.spec[types[x]][c], ["securityContext", "runAsUser"])
	nested_info2.valid == false

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": common_lib.remove_last_point(sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.%s", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name, nested_info2.searchKey])),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("3 metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser should be defined", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is undefined", [metadata.name, specInfo.path, types[x], specInfo.spec[types[x]][c].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c]),
	}
}
