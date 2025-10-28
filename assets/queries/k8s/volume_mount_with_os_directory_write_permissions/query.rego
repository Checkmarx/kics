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
	is_insecure_mount(volumeMounts[v])
	
	# Don't flag if volume is configMap or secret (always read-only)
	not is_inherently_readonly_volume(specInfo.spec.volumes, volumeMounts[v].name)

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
	container := specInfo.spec[types[x]][_]
	volumeMounts := container.volumeMounts
	is_os_dir(volumeMounts[v].mountPath)
    check_if_mount_missing_props(volumeMounts[v])
	
	# Don't flag if volume is configMap or secret (always read-only)
	not is_inherently_readonly_volume(specInfo.spec.volumes, volumeMounts[v].name)

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

# Check if mount path is a sensitive OS directory
is_os_dir(mountPath) {
	# Critical system directories
	critical_dirs := {"/bin", "/sbin", "/boot", "/dev", "/etc", "/lib", "/proc", "/root", "/sys"}
	startswith(mountPath, critical_dirs[_])
}

is_os_dir(mountPath) {
	# Root filesystem
	mountPath == "/"
}

is_os_dir(mountPath) {
	# /usr and /var with exceptions for legitimate subdirectories
	secondary_dirs := {"/usr", "/var"}
	startswith(mountPath, secondary_dirs[_])
	not is_legitimate_subdir(mountPath)
}

# Known legitimate subdirectories
is_legitimate_subdir(mountPath) {
	legitimate_subdirs := {
		"/var/log", "/var/run/docker.sock", "/var/lib/docker", 
		"/var/cache", "/var/run/secrets", "/usr/share", "/usr/local"
	}
	startswith(mountPath, legitimate_subdirs[_])
}

# Check if volume is inherently read-only (configMap, secret)
is_inherently_readonly_volume(volumes, volumeName) {
    volumes[i].name == volumeName
    readonly_types := ["configMap", "secret"]
    volumes[i][readonly_types[_]]
}
