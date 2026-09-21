package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	not common_lib.valid_key(resource.spec.template.spec, "affinity")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity should be set", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	not common_lib.valid_key(affinity, "pod_anti_affinity")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity should be set", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec", "affinity"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	common_lib.valid_key(affinity, "pod_anti_affinity")

	podAntiAffinity := affinity.pod_anti_affinity

	not common_lib.valid_key(podAntiAffinity, "preferred_during_scheduling_ignored_during_execution")
	not common_lib.valid_key(podAntiAffinity, "required_during_scheduling_ignored_during_execution")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution and/or kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution should be set", [name, name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution and/or kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution are undefined", [name, name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec", "affinity", "pod_anti_affinity"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	common_lib.valid_key(affinity, "pod_anti_affinity")

	podAntiAffinity := affinity.pod_anti_affinity

	common_lib.valid_key(podAntiAffinity, "preferred_during_scheduling_ignored_during_execution")

	pref := podAntiAffinity.preferred_during_scheduling_ignored_during_execution

	object.get(pref.pod_affinity_term, "topology_key", "undefined") != "kubernetes.io/hostname"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.topology_key should be set to 'kubernetes.io/hostname'", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.topology_key is invalid or undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec", "affinity", "pod_anti_affinity", "preferred_during_scheduling_ignored_during_execution"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	common_lib.valid_key(affinity, "pod_anti_affinity")

	podAntiAffinity := affinity.pod_anti_affinity

	common_lib.valid_key(podAntiAffinity, "preferred_during_scheduling_ignored_during_execution")

	pref := podAntiAffinity.preferred_during_scheduling_ignored_during_execution

	object.get(pref.pod_affinity_term, "topology_key", "undefined") == "kubernetes.io/hostname"

	templateLabels := resource.spec.template.metadata.labels
	selectorLabels := pref.pod_affinity_term.label_selector.match_labels

	not match_labels(templateLabels, selectorLabels)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.label_selector.match_labels match any label on template metadata", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.label_selector.match_labels don't match any label on template metadata", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec", "affinity", "pod_anti_affinity", "preferred_during_scheduling_ignored_during_execution", "pod_affinity_term", "label_selector", "match_labels"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	common_lib.valid_key(affinity, "pod_anti_affinity")

	podAntiAffinity := affinity.pod_anti_affinity

	common_lib.valid_key(podAntiAffinity, "required_during_scheduling_ignored_during_execution")

	pref := podAntiAffinity.required_during_scheduling_ignored_during_execution

	object.get(pref, "topology_key", "undefined") != "kubernetes.io/hostname"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution.topology_key should be set to 'kubernetes.io/hostname'", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution.topology_key is invalid or undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec", "affinity", "pod_anti_affinity", "required_during_scheduling_ignored_during_execution"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	common_lib.valid_key(affinity, "pod_anti_affinity")

	podAntiAffinity := affinity.pod_anti_affinity

	common_lib.valid_key(podAntiAffinity, "required_during_scheduling_ignored_during_execution")

	pref := podAntiAffinity.required_during_scheduling_ignored_during_execution

	object.get(pref, "topology_key", "undefined") == "kubernetes.io/hostname"

	templateLabels := resource.spec.template.metadata.labels
	selectorLabels := pref.label_selector.match_labels

	not match_labels(templateLabels, selectorLabels)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution.label_selector.match_labels match any label on template metadata", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution.label_selector.match_labels don't match any label on template metadata", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_deployment", name, "spec"], ["template", "spec", "affinity", "pod_anti_affinity", "required_during_scheduling_ignored_during_execution", "label_selector", "match_labels", "match_labels"]),
	}
}

match_labels(templateLabels, selectorLabels) {
	some Key
	templateLabels[Key] == selectorLabels[Key]
} else = false {
	true
}
