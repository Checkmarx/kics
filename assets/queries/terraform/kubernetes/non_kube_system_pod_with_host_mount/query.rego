package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]
	metadata := resource.metadata
	not metadata.namespace
	volumes := resource.spec.volume
	volumes[_].path
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec.volume.host_path.path", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' in non kube-system namespace '%s' should not have host_path '%s' mounted", [
			metadata.name,
			"default",
			volumes[j].path,
		]),
		"keyActualValue": sprintf("Resource name '%s' in non kube-system namespace '%s' has a host_path '%s' mounted", [
			metadata.name,
			"default",
			volumes[j].path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]
	metadata := resource.metadata
	namespace := metadata.namespace
	namespace != "kube-system"
	volumes := resource.spec.volume
	volumes[_].path
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec.volume.host_path.path", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' in non kube-system namespace '%s' should not have host_path '%s' mounted", [
			metadata.name,
			metadata.namespace,
			volumes[j].path,
		]),
		"keyActualValue": sprintf("Resource name '%s' in non kube-system namespace '%s' has a host_path '%s' mounted", [
			metadata.name,
			metadata.namespace,
			volumes[j].path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_persistent_volume[name]
	metadata := resource.metadata
	not metadata.namespace
	volumes := resource.spec.volume
	volumes[_].path
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_persistent_volume",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_persistent_volume[%s].spec.volume.host_path.path", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' in non kube-system namespace '%s' should not have host_path '%s' mounted", [
			metadata.name,
			"default",
			volumes[j].path,
		]),
		"keyActualValue": sprintf("Resource name '%s' in non kube-system namespace '%s' has a host_path '%s' mounted", [
			metadata.name,
			"default",
			volumes[j].path,
		]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_persistent_volume[name]
	metadata := resource.metadata
	namespace := metadata.namespace
	namespace != "kube-system"
	volumes := resource.spec.volume
	volumes[_].path
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_persistent_volume",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_persistent_volume[%s].spec.volume.host_path.path", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' in non kube-system namespace '%s' should not have host_path '%s' mounted", [
			metadata.name,
			metadata.namespace,
			volumes[j].path,
		]),
		"keyActualValue": sprintf("Resource name '%s' in non kube-system namespace '%s' has a host_path '%s' mounted", [
			metadata.name,
			metadata.namespace,
			volumes[j].path,
		]),
	}
}
