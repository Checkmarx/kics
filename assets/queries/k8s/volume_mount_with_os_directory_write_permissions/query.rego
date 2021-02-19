package Cx

CxPolicy[result] {
	resource := input.document[i]
	types := {"initContainers", "containers"}
	containers := resource.spec[types[x]]
	volumeMounts := containers[_].volumeMounts
	is_OS_Dir(volumeMounts[v].mountPath)
	volumeMounts[v].readOnly == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.volumeMounts.name=%s.readyOnly", [resource.metadata.name, types[x], volumeMounts[v].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s.volumeMounts[%s].readOnly is true", [types[x], volumeMounts[v].name]),
		"keyActualValue": sprintf("spec.%s.volumeMounts[%s].readOnly is false", [types[x], volumeMounts[v].name]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	types := {"initContainers", "containers"}
	containers := resource.spec[types[x]]
	volumeMounts := containers[_].volumeMounts
	is_OS_Dir(volumeMounts[v].mountPath)
	object.get(volumeMounts[v], "readOnly", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.volumeMounts.name=%s", [resource.metadata.name, types[x], volumeMounts[v].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s.volumeMounts[%s].readOnly is set", [types[x], volumeMounts[v].name]),
		"keyActualValue": sprintf("spec.%s.volumeMounts[%s].readOnly is undefined", [types[x], volumeMounts[v].name]),
	}
}

is_OS_Dir(mountPath) = result {
	hostSensitiveDir = {"/bin", "/sbin", "/boot", "/cdrom", "/dev", "/etc", "/home", "/lib", "/media", "/proc", "/root", "/run", "/seLinux", "/srv", "/usr", "/var"}
	result = startswith(mountPath, hostSensitiveDir[_])
} else = result {
	result = mountPath == "/"
}

listcontains(dirs, elem) {
	startswith(elem, dirs[_])
}
