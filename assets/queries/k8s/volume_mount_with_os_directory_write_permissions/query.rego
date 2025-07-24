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

	container := specInfo.spec[types[x]][j]
	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
	type := is_insecure_mount(volumeMounts[v])


	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"issueType": "IncorrectValue",
		"searchValue": sprintf("%s%s", [document.kind, type]),
		"keyExpectedValue": sprintf("The properties readOnly and recursiveReadOnly in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}} are set to true and Enabled, respectively", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"keyActualValue": sprintf("The properties readOnly or recursiveReadOnly in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}} are set to false or Disabled, respectively", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x],j, "volumeMounts", v]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	volumes := specInfo.spec.volumes
    safe_volumn := check_safe_volumes(volumes)
    safe_volumn == ""

	container := specInfo.spec[types[x]][j]
	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
    type := check_if_mount_missing_props(volumeMounts[v])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"issueType": "MissingAttribute",
		"searchValue": sprintf("%s%s", [document.kind, type]),
		"keyExpectedValue": sprintf("The properties readOnly and recursiveReadOnly in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}} should be defined and set to true and Enabled, respectively", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"keyActualValue": sprintf("Either readOnly or recursiveReadOnly is missing in metadata.name={{%s}}.%s.%s.name={{%s}}.volumeMounts.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name, metadata.name, specInfo.path, types[x], container.name, volumeMounts[v].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x],j, "volumeMounts", v]),
	}
}

is_insecure_mount(mount) = type{
    mount.readOnly == false
    type := "readOnly"
} else = type{
    mount.recursiveReadOnly == "Disabled"
    type := "recursiveReadOnly"
}

check_if_mount_missing_props(mount) = type {
    not common_lib.valid_key(mount, "readOnly")
    type := "readOnly"
} else = type{
    not common_lib.valid_key(mount, "recursiveReadOnly")
    type := "recursiveReadOnly"
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
