package Cx

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)
	volumeMounts.read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].volume_mount.read_only is set to true", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].volume_mount.read_only is set to false", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMounts[j].read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].volume_mount[%d].read_only is set to true", [resourceType, name, types[x], y, j]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].volume_mount[%d].read_only is set to false", [resourceType, name, types[x], y, j]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)
	volumeMounts.read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.volume_mount", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.volume_mount.read_only is set to true", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.volume_mount.read_only is set to false", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMounts[j].read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.volume_mount", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.volume_mount[%d].read_only is set to true", [resourceType, name, types[x], j]),
		"keyActualValue": sprintf("%s[%s].spec.%s.volume_mount[%d].read_only is set to false", [resourceType, name, types[x], j]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)

	object.get(volumeMounts, "read_only", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].volume_mount.read_only is set", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].volume_mount.read_only is undefined", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])

	object.get(volumeMounts[j], "read_only", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].volume_mount[%d].read_only is set", [resourceType, name, types[x], y, j]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].volume_mount[%d].read_only is undefined", [resourceType, name, types[x], y, j]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)

	object.get(volumeMounts, "read_only", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.volume_mount", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.volume_mount.read_only is set", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.volume_mount.read_only is undefined", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])

	object.get(volumeMounts[j], "read_only", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.volume_mount", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.volume_mount[%d].read_only is set", [resourceType, name, types[x], j]),
		"keyActualValue": sprintf("%s[%s].spec.%s.volume_mount[%d].read_only is undefined", [resourceType, name, types[x], j]),
	}
}

is_os_dir(volumeMounts) = result {
	hostSensitiveDir = {"/bin", "/sbin", "/boot", "/cdrom", "/dev", "/etc", "/home", "/lib", "/media", "/proc", "/root", "/run", "/seLinux", "/srv", "/usr", "/var"}
	result = startswith(volumeMounts.mount_path, hostSensitiveDir[_])
} else = result {
	result = volumeMounts.mount_path == "/"
}
