package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	is_object(containers[y].volume_mount) == true
	is_os_dir(containers[y].volume_mount)

	containers[y].volume_mount.read_only == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount.read_only", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only should be set to true", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only is set to false", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "volume_mount", "read_only"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMounts[j].read_only == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount.read_only", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only should be set to true", [resourceType, name, specInfo.path, types[x], y, j]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only is set to false", [resourceType, name, specInfo.path, types[x], y, j]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "volume_mount", j, "read_only"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)
	volumeMounts.read_only == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount.read_only", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount.read_only should be set to true", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount.read_only is set to false", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "volume_mount", "read_only"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMounts[j].read_only == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount.read_only", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only should be set to true", [resourceType, name, specInfo.path, types[x], j]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only is set to false", [resourceType, name, specInfo.path, types[x], j]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "volume_mount", j, "read_only"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)

	not common_lib.valid_key(volumeMounts, "read_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount.read_only is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "volume_mount"]),
		"remediation": "read_only = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	volumeMounts := containers[y].volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMountTypes := volumeMounts[_]

	not common_lib.valid_key(volumeMountTypes, "read_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only should be set", [resourceType, name, specInfo.path, types[x], y, volumeMountTypes]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].volume_mount[%d].read_only is undefined", [resourceType, name, specInfo.path, types[x], y, volumeMountTypes]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "volume_mount", j]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_object(volumeMounts) == true
	is_os_dir(volumeMounts)

	not common_lib.valid_key(volumeMounts, "read_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount.read_only should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount.read_only is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "volume_mount"]),
		"remediation": "read_only = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	volumeMounts := containers.volume_mount
	is_array(volumeMounts) == true
	is_os_dir(volumeMounts[j])
	volumeMountTypes := volumeMounts[j]

	not common_lib.valid_key(volumeMountTypes, "read_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.volume_mount", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only should be set", [resourceType, name, specInfo.path, types[x], j]),
		"keyActualValue": sprintf("%s[%s].%s.%s.volume_mount[%d].read_only is undefined", [resourceType, name, specInfo.path, types[x], j]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "volume_mount", j]),
		"remediation": "read_only = true",
		"remediationType": "addition",
	}
}

is_os_dir(volumeMounts) {
	hostSensitiveDir = {"/bin", "/sbin", "/boot", "/cdrom", "/dev", "/etc", "/home", "/lib", "/media", "/proc", "/root", "/run", "/seLinux", "/srv", "/usr", "/var"}
	startswith(volumeMounts.mount_path, hostSensitiveDir[_])
} else {
	volumeMounts.mount_path == "/"
}
