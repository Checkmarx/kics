package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]
	metadata := resource.metadata
	volumes := resource.spec.volume
	isOSDir(volumes[j].path)
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec.volume.host_path.path", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Workload name '%s' should not mount a host sensitive OS directory '%s' with host_path", [
			metadata.name,
			volumes[j].path,
		]),
		"keyActualValue": sprintf("Workload name '%s' is mounting a host sensitive OS directory '%s' with host_path", [
			resource.metadata.name,
			volumes[j].path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_persistent_volume[name]
	metadata := resource.metadata
	volumes := resource.spec.volume
	isOSDir(volumes[j].path)
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_persistent_volume",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_persistent_volume[%s].spec.volume.host_path.path", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Workload name '%s' should not mount a host sensitive OS directory '%s' with host_path", [
			metadata.name,
			volumes[j].path,
		]),
		"keyActualValue": sprintf("Workload name '%s' is mounting a host sensitive OS directory '%s' with host_path", [
			resource.metadata.name,
			volumes[j].path,
		]),
	}
}

isOSDir(mountPath) = result {
	hostSensitiveDir = {
		"/bin", "/sbin", "/boot", "/cdrom",
		"/dev", "/etc", "/home", "/lib",
		"/media", "/proc", "/root", "/run",
		"/seLinux", "/srv", "/usr", "/var",
	}

	result = listcontains(hostSensitiveDir, mountPath)
} else = result {
	result = mountPath == "/"
}

listcontains(dirs, elem) {
	startswith(elem, dirs[_])
}
