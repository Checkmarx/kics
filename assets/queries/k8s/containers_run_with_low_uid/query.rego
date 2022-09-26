package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

# container defines runAsUser
checkUser(specInfo, container, containerType, document, metadata) = result {
	uid := container.securityContext.runAsUser
	to_number(uid) < 10000

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser=%d", [metadata.name, specInfo.path, containerType, container.name, uid]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser should be set to a UID >= 10000", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is set to a low UID", [metadata.name, specInfo.path, containerType, container.name]),
	}
}

# pod defines runAsUser and container inherits this setting
checkUser(specInfo, container, containerType, document, metadata) = result {

	nested_info := common_lib.get_nested_values_info(container, ["securityContext", "runAsUser"])
	nested_info.valid == false

	uid := specInfo.spec.securityContext.runAsUser
	to_number(uid) < 10000

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser=%d", [metadata.name, specInfo.path, uid]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser should be set to a UID >= 10000", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.runAsUser is set to a low UID", [metadata.name, specInfo.path]),
	}
}

# neither pod nor container define runAsUser
checkUser(specInfo, container, containerType, document, metadata) = result {
	nested_info := common_lib.get_nested_values_info(specInfo.spec, ["securityContext", "runAsUser"])
	nested_info.valid == false

	nested_info2 := common_lib.get_nested_values_info(container, ["securityContext", "runAsUser"])
	nested_info2.valid == false

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": common_lib.remove_last_point(sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.%s", [metadata.name, specInfo.path, containerType, container.name, nested_info2.searchKey])),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser should be defined", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.runAsUser is undefined", [metadata.name, specInfo.path, containerType, container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	result := checkUser(specInfo, specInfo.spec[types[x]][_], types[x], document, metadata)
}
