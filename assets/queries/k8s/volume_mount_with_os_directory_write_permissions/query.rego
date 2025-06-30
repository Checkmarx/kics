package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
    volumes := specInfo.spec.volumes
    safe_volumn := check_safe_volumes(volumes)
    safe_volumn == ""

	container := specInfo.spec[types[x]][_]
	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
	is_insecure_mount(volumeMounts[v])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The properties readOnly and recursiveReadOnly in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}} are set to true and Enabled, respectively", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"keyActualValue": sprintf("The properties readOnly or recursiveReadOnly in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}} are set to false or Disabled, respectively", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	volumes := specInfo.spec.volumes
    safe_volumn := check_safe_volumes(volumes)
    safe_volumn == ""

	container := specInfo.spec[types[x]][_]
	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
    check_if_mount_missing_props(volumeMounts[v])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("The properties readOnly and recursiveReadOnly in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}} should be defined and set to true and Enabled, respectively", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"keyActualValue": sprintf("Either readOnly or recursiveReadOnly is missing in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name, metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
	}
}

is_insecure_mount(mount) {
    mount.readOnly == false
} else {
    mount.recursiveReadOnly == "Disabled"
}

check_if_mount_missing_props(mount) = true {
    not common_lib.valid_key(mount, "readOnly")
} else = true {
    not common_lib.valid_key(mount, "recursiveReadOnly")
}

is_os_dir(mountPath) {
	hostSensitiveDir = {"/bin", "/sbin", "/boot", "/cdrom", "/dev", "/etc", "/home", "/lib", "/media", "/proc", "/root", "/run", "/seLinux", "/srv", "/usr", "/var"}
	startswith(mountPath, hostSensitiveDir[_])
} else {
	mountPath == "/"
}

check_safe_volumes(volumes) = x {
    safe_keys := ["configMap", "secret"]
    some i,k
    k = safe_keys[_]
    volumes[i][k]
    not is_null(volumes[i][k])
    x := k
} else = "" {
    true
}
