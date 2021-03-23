package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	volumes := resource.spec.volume

	volumes[c].host_path.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.volume", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.volume[%d].host_path.path is not '/var/run/docker.sock'", [c]),
		"keyActualValue": sprintf("spec.volume[%d].host_path.path is '/var/run/docker.sock'", [c]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource

	listKinds := {"kubernetes_deployment", "kubernetes_daemonset", "kubernetes_job", "kubernetes_stateful_set", "kubernetes_replication_controller"}

	k8s := object.get(resource, listKinds[x], "undefined")
	k8s != "undefined"

	spec := k8s[name].spec.template.spec
	volumes := spec.volume
	volumes[c].host_path.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.template.spec.volume", [listKinds[x], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.template.spec.volume[%d].host_path.path is not '/var/run/docker.sock'", [c]),
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
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.volume", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.job_template.spec.template.spec.volume[%d].host_path.path is not '/var/run/docker.sock'", [c]),
		"keyActualValue": sprintf("spec.job_template.spec.template.spec.volume[%d].host_path.path is '/var/run/docker.sock'", [c]),
	}
}
