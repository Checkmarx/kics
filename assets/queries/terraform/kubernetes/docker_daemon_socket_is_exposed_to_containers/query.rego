package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	volumes := resource.spec.volume

	volumes[c].host_path.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec.volume", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.volume[%d].host_path.path should not be '/var/run/docker.sock'", [c]),
		"keyActualValue": sprintf("spec.volume[%d].host_path.path is '/var/run/docker.sock'", [c]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	listKinds := {"kubernetes_deployment", "kubernetes_daemonset", "kubernetes_job", "kubernetes_stateful_set", "kubernetes_replication_controller"}
	kind := listKinds[x]
	common_lib.valid_key(resource, kind)

	workload := resource[kind][name]
	spec := workload.spec.template.spec
	volumes := spec.volume
	volumes[c].host_path.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"resourceType": kind,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.spec.volume", [kind, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.template.spec.volume[%d].host_path.path should not be '/var/run/docker.sock'", [c]),
		"keyActualValue": sprintf("spec.template.spec.volume[%d].host_path.path is '/var/run/docker.sock'", [c]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]
	spec := resource.spec.job_template.spec.template.spec
	volumes := spec.volume
	volumes[c].host_path.path == "/var/run/docker.sock"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.volume", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.job_template.spec.template.spec.volume[%d].host_path.path should not be '/var/run/docker.sock'", [c]),
		"keyActualValue": sprintf("spec.job_template.spec.template.spec.volume[%d].host_path.path is '/var/run/docker.sock'", [c]),
	}
}
