package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
	volumeMounts[v].readOnly == false

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}.readOnly", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}.readOnly is true", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}.readOnly is false", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
	not common_lib.valid_key(volumeMounts[v], "readOnly")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}.readOnly should be defined and set to true", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}.readOnly is undefined", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
	}
}

is_os_dir(mountPath) {
	hostSensitiveDir = {"/bin", "/sbin", "/boot", "/cdrom", "/dev", "/etc", "/home", "/lib", "/media", "/proc", "/root", "/run", "/seLinux", "/srv", "/usr", "/var"}
	startswith(mountPath, hostSensitiveDir[_])
} else {
	mountPath == "/"
}
