package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	resource.kind == k8sLib.valid_pod_spec_kind_list[_]
	specInfo := k8sLib.getSpecInfo(resource)
	volumes := specInfo.spec.volumes
	common_lib.isOSDir(volumes[j].hostPath.path)
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path", [metadata.name, specInfo.path, volumes[j].name]),
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
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["volumes", j ,"hostPath", "path"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	not common_lib.inArray(k8sLib.valid_pod_spec_kind_list, resource.kind)
	specInfo := k8sLib.getSpecInfo(resource)
	volumes := specInfo.spec.volumes
	common_lib.isOSDir(volumes[j].hostPath.path)
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path", [metadata.name, specInfo.path, volumes[j].name]),
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
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["volumes", j ,"hostPath", "path"])
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
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostPath.path", [metadata.name]),
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
		"searchLine": common_lib.build_search_line(["spec"], ["hostPath", "path"])
	}
}
