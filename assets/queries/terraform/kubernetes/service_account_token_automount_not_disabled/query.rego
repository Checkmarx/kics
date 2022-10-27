package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	not common_lib.valid_key(resource.spec, "automount_service_account_token")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.automount_service_account_token should be set", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.automount_service_account_token is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod", name, "spec"],[]),
		"remediation": "automount_service_account_token = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	resource.spec.automount_service_account_token == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec.automount_service_account_token", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.automount_service_account_token should be set to false", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.automount_service_account_token is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod", name, "spec"],["automount_service_account_token"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

listKinds := {"kubernetes_deployment", "kubernetes_daemonset", "kubernetes_job", "kubernetes_stateful_set", "kubernetes_replication_controller"}

CxPolicy[result] {
	resource := input.document[i].resource

	k8 := resource[listKinds[x]][name].spec.template.spec

	not common_lib.valid_key(k8, "automount_service_account_token")

	result := {
		"documentId": input.document[i].id,
		"resourceType": listKinds[x],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.spec", [listKinds[x], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.template.spec.automount_service_account_token should be set", [listKinds[x], name]),
		"keyActualValue": sprintf("%s[%s].spec.template.spec.automount_service_account_token is undefined", [listKinds[x], name]),
		"searchLine": common_lib.build_search_line(["resource", listKinds[x], name, "spec", "template", "spec"],[]),
		"remediation": "automount_service_account_token = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource

	resource[listKinds[x]][name].spec.template.spec.automount_service_account_token == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": listKinds[x],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.spec.automount_service_account_token", [listKinds[x], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.template.spec.automount_service_account_token should be set to false", [listKinds[x], name]),
		"keyActualValue": sprintf("%s[%s].spec.template.spec.automount_service_account_token is set to true", [listKinds[x], name]),
		"searchLine": common_lib.build_search_line(["resource", listKinds[x], name, "spec", "template", "spec"],["automount_service_account_token"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]

	not common_lib.valid_key(resource.spec.jobTemplate.spec.template.spec, "automount_service_account_token")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.jobTemplate.spec.template.spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.automount_service_account_token should be set", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.automount_service_account_token is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_cron_job", name, "spec", "template", "spec", "template", "spec"],[]),
		"remediation": "automount_service_account_token = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]

	resource.spec.job_template.spec.template.spec.automount_service_account_token == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.automount_service_account_token", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.automount_service_account_token should be set to false", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.spec.automount_service_account_token is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_cron_job", name, "spec", "template", "spec", "template", "spec"],["automount_service_account_token"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
