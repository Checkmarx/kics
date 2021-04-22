package Cx

listKinds := {"kubernetes_ingress", "kubernetes_config_map", "kubernetes_secret", "kubernetes_service", "kubernetes_cron_job", "kubernetes_service_account", "kubernetes_role", "kubernetes_role_binding", "kubernetes_pod", "kubernetes_deployment", "kubernetes_daemonset", "kubernetes_job", "kubernetes_stateful_set", "kubernetes_replication_controller"}

CxPolicy[result] {
	resource := input.document[i].resource

	k8s := object.get(resource, listKinds[x], "undefined")
	k8s != "undefined"

	object.get(k8s[name].metadata, "namespace", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].metadata", [listKinds[x], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].metadata is set", [listKinds[x], name]),
		"keyActualValue": sprintf("%s[%s].metadata is undefined", [listKinds[x], name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource

	k8s := object.get(resource, listKinds[x], "undefined")
	k8s != "undefined"

	k8s[name].metadata.namespace == "default"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].metadata.namespace", [listKinds[x], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].metadata.namespace is not set to 'default'", [listKinds[x], name]),
		"keyActualValue": sprintf("%s[%s].metadata.namespace is set to 'default'", [listKinds[x], name]),
	}
}
