package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	resource.kind == "Pod"
	volumes := resource.spec.volumes
	common_lib.isOSDir(volumes[j].hostPath.path)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.volumes.name={{%s}}.hostPath.path", [metadata.name, volumes[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Workload name '%s' of kind '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
			resource.metadata.name,
			resource.kind,
			volumes[j].hostPath.path,
		]),
		"keyActualValue": sprintf("Workload name '%s' of kind '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
			resource.metadata.name,
			resource.kind,
			volumes[j].hostPath.path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	resource.kind != "Pod"
	spec := resource.spec.template.spec
	volumes := spec.volumes
	common_lib.isOSDir(volumes[j].hostPath.path)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.volumes.name={{%s}}.hostPath.path", [metadata.name, volumes[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Workload name '%s' of kind '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
			resource.metadata.name,
			resource.kind,
			volumes[j].hostPath.path,
		]),
		"keyActualValue": sprintf("Workload name '%s' of kind '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
			resource.metadata.name,
			resource.kind,
			volumes[j].hostPath.path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	resource.kind == "PersistentVolume"
	hostPath := resource.spec.hostPath
	common_lib.isOSDir(hostPath.path)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.spec.hostPath.path", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("PersistentVolume name '%s' of kind '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
			resource.metadata.name,
			resource.kind,
			hostPath.path,
		]),
		"keyActualValue": sprintf("PersistentVolume name '%s' of kind '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
			resource.metadata.name,
			resource.kind,
			hostPath.path,
		]),
	}
}
