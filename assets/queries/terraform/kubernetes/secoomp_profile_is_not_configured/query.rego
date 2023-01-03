package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#pod
CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	metadata := resource.metadata
	common_lib.valid_key(metadata, "annotations")

	annotations := metadata.annotations
	not common_lib.valid_key(annotations, "${seccomp.security.alpha.kubernetes.io/defaultProfileName}")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].metadata.annotations", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName should be set", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	metadata := resource.metadata
	common_lib.valid_key(metadata, "annotations")

	annotations := metadata.annotations
	common_lib.valid_key(annotations, "${seccomp.security.alpha.kubernetes.io/defaultProfileName}")

	seccomp := annotations["${seccomp.security.alpha.kubernetes.io/defaultProfileName}"]

	seccomp != "runtime/default"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].metadata.annotations", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is 'runtime/default'", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is '%s'", [name, seccomp]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	metadata := resource.metadata
	not common_lib.valid_key(metadata, "annotations")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].metadata.annotations should be set", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].metadata.annotations is undefined", [name]),
	}
}

# cron_job
CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]

	metadata := resource.spec.job_template.spec.template.metadata
	not common_lib.valid_key(metadata, "annotations")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations should be set", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]

	metadata := resource.spec.job_template.spec.template.metadata
	common_lib.valid_key(metadata, "annotations")

	annotations := metadata.annotations
	not common_lib.valid_key(annotations, "${seccomp.security.alpha.kubernetes.io/defaultProfileName}")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName should be set", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]

	metadata := resource.spec.job_template.spec.template.metadata
	common_lib.valid_key(metadata, "annotations")

	annotations := metadata.annotations
	common_lib.valid_key(annotations, "${seccomp.security.alpha.kubernetes.io/defaultProfileName}")

	seccomp := annotations["${seccomp.security.alpha.kubernetes.io/defaultProfileName}"]
	seccomp != "runtime/default"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is 'runtime/default'", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.job_template.spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is '%s'", [name, seccomp]),
	}
}

#general
resources := {"kubernetes_cron_job", "kubernetes_pod"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	resourceType != resources[x]

	metadata := resource[name].spec.template.metadata
	not common_lib.valid_key(metadata, "annotations")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.metadata", [resourceType, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.template.metadata.annotations should be set", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].spec.template.metadata.annotations is undefined", [resourceType, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	resourceType != resources[x]

	metadata := resource[name].spec.template.metadata
	common_lib.valid_key(metadata, "annotations")

	annotations := metadata.annotations
	not common_lib.valid_key(annotations, "${seccomp.security.alpha.kubernetes.io/defaultProfileName}")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.metadata.annotations", [resourceType, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName should be set", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is undefined", [resourceType, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	resourceType != resources[x]

	metadata := resource[name].spec.template.metadata
	common_lib.valid_key(metadata, "annotations")

	annotations := metadata.annotations
	common_lib.valid_key(annotations, "${seccomp.security.alpha.kubernetes.io/defaultProfileName}")

	seccomp := annotations["${seccomp.security.alpha.kubernetes.io/defaultProfileName}"]

	seccomp != "runtime/default"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.metadata.annotations", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is 'runtime/default'", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].spec.template.metadata.annotations.seccomp.security.alpha.kubernetes.io/defaultProfileName is '%s'", [resourceType, name, seccomp]),
	}
}
