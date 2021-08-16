package Cx

import data.generic.terraform as terraLib
import data.generic.common as common_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)
	volumeMounts.read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only is set to true", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only is set to false", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMounts[j].read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only is set to true", [resourceType, name, specInfo.path, types[x], y, j]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only is set to false", [resourceType, name, specInfo.path, types[x], y, j]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)
	volumeMounts.read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount.read_only is set to true", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount.read_only is set to false", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMounts[j].read_only == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only is set to true", [resourceType, name, specInfo.path, types[x], j]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only is set to false", [resourceType, name, specInfo.path, types[x], j]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)

	not common_lib.valid_key(volumeMounts, "read_only")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only is set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only is undefined", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMountTypes := volumeMounts[_]

	not common_lib.valid_key(volumeMountTypes, "read_only")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only is set", [resourceType, name, specInfo.path, types[x], y, volumeMountTypes]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only is undefined", [resourceType, name, specInfo.path, types[x], y, volumeMountTypes]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)

	not common_lib.valid_key(volumeMounts, "read_only")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount.read_only is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount.read_only is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMountTypes := volumeMounts[_]

	not common_lib.valid_key(volumeMountTypes, "read_only")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only is set", [resourceType, name, specInfo.path, types[x], volumeMountTypes]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only is undefined", [resourceType, name, specInfo.path, types[x], volumeMountTypes]),
	}
}

is_os_dir(volumeMounts) {
	hostSensitiveDir = {"/bin", "/sbin", "/boot", "/cdrom", "/dev", "/etc", "/home", "/lib", "/media", "/proc", "/root", "/run", "/seLinux", "/srv", "/usr", "/var"}
	startswith(volumeMounts.mount_path, hostSensitiveDir[_])
} else {
	volumeMounts.mount_path == "/"
}
