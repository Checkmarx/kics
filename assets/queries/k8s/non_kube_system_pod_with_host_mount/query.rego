package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	not metadata.namespace
	resource.kind == k8sLib.valid_pod_spec_kind_list[_]
	specInfo := k8sLib.getSpecInfo(resource)
	volumes := specInfo.spec.volumes
	volumes[j].hostPath.path
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path", [metadata.name, specInfo.path, volumes[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' should not have hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			"default",
			volumes[j].hostPath.path,
		]),
		"keyActualValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' has a hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			"default",
			volumes[j].hostPath.path,
		]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["volumes", j ,"hostPath", "path"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	namespace := metadata.namespace
	namespace != "kube-system"
	resource.kind == k8sLib.valid_pod_spec_kind_list[_]
	specInfo := k8sLib.getSpecInfo(resource)
	volumes := specInfo.spec.volumes
	volumes[j].hostPath.path
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path", [metadata.name,specInfo.path, volumes[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' should not have hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			metadata.namespace,
			volumes[j].hostPath.path,
		]),
		"keyActualValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' has a hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			metadata.namespace,
			volumes[j].hostPath.path,
		]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["volumes", j ,"hostPath", "path"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	namespace := metadata.namespace
	namespace != "kube-system"
	not common_lib.inArray(k8sLib.valid_pod_spec_kind_list, resource.kind)
	volumes := resource.spec.template.spec.volumes
	volumes[j].hostPath.path
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.volumes.name={{%s}}.hostPath.path", [metadata.name, volumes[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' should not have hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			"default",
			volumes[j].hostPath.path,
		]),
		"keyActualValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' has a hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			"default",
			volumes[j].hostPath.path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	not metadata.namespace
	not common_lib.inArray(k8sLib.valid_pod_spec_kind_list, resource.kind)
	volumes := resource.spec.template.spec.volumes
	volumes[j].hostPath.path
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.volumes.name={{%s}}.hostPath.path", [metadata.name, volumes[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			"default",
			volumes[j].hostPath.path,
		]),
		"keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' has a hostPath '%s' mounted", [
			metadata.name,
			resource.kind,
			"default",
			volumes[j].hostPath.path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	resource.kind == "PersistentVolume"
	metadata.namespace != "kube-system"
	path := resource.spec.hostPath.path
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostPath.path", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
			metadata.name,
			resource.kind,
			metadata.namespace,
			path,
		]),
		"keyActualValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
			metadata.name,
			resource.kind,
			metadata.namespace,
			path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	resource.kind == "PersistentVolume"
	not metadata.namespace
	path := resource.spec.hostPath.path
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.hostPath.path", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
			metadata.name,
			resource.kind,
			"default",
			path,
		]),
		"keyActualValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
			metadata.name,
			resource.kind,
			"default",
			path,
		]),
	}
}
