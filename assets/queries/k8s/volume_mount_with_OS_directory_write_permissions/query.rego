package Cx

CxPolicy[result] {
	resource := input.document[i]
	containers := resource.spec.containers
	volumeMounts := containers[_].volumeMounts
	is_OS_Dir(volumeMounts[v].mountPath)
	volumeMounts[v].readOnly == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.volumeMounts.name=%s.readyOnly", [resource.metadata.name, volumeMounts[v].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.containers.volumeMounts[%s].readOnly is true", [volumeMounts[v].name]),
		"keyActualValue": sprintf("spec.containers.volumeMounts[%s].readOnly is false", [volumeMounts[v].name]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	containers := resource.spec.containers
	volumeMounts := containers[_].volumeMounts
	is_OS_Dir(volumeMounts[v].mountPath)
	object.get(volumeMounts[v], "readOnly", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.volumeMounts.name=%s", [resource.metadata.name, volumeMounts[v].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.containers.volumeMounts[%s].readOnly is set", [volumeMounts[v].name]),
		"keyActualValue": sprintf("spec.containers.volumeMounts[%s].readOnly is undefined", [volumeMounts[v].name]),
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
