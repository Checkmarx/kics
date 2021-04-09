package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	object.get(resource.spec.template.spec, "affinity", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity is set", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	object.get(affinity, "pod_anti_affinity", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity is set", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	object.get(affinity, "pod_anti_affinity", "undefined") != "undefined"

	podAntiAffinity := affinity.pod_anti_affinity

	object.get(podAntiAffinity, "preferred_during_scheduling_ignored_during_execution", "undefined") == "undefined"
	object.get(podAntiAffinity, "required_during_scheduling_ignored_during_execution", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution and/or kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution are/is set", [name, name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution and/or kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution are undefined", [name, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	object.get(affinity, "pod_anti_affinity", "undefined") != "undefined"

	podAntiAffinity := affinity.pod_anti_affinity

	object.get(podAntiAffinity, "preferred_during_scheduling_ignored_during_execution", "undefined") != "undefined"

	pref := podAntiAffinity.preferred_during_scheduling_ignored_during_execution

	object.get(pref.pod_affinity_term, "topology_key", "undefined") != "kubernetes.io/hostname"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.topology_key is set and is 'kubernetes.io/hostname'", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.topology_key is invalid or undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	object.get(affinity, "pod_anti_affinity", "undefined") != "undefined"

	podAntiAffinity := affinity.pod_anti_affinity

	object.get(podAntiAffinity, "preferred_during_scheduling_ignored_during_execution", "undefined") != "undefined"

	pref := podAntiAffinity.preferred_during_scheduling_ignored_during_execution

	object.get(pref.pod_affinity_term, "topology_key", "undefined") == "kubernetes.io/hostname"

	templateLabels := resource.spec.template.metadata.labels
	selectorLabels := pref.pod_affinity_term.label_selector.match_labels

	match_labels(templateLabels, selectorLabels) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.label_selector.match_labels match any label on template metadata", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.preferred_during_scheduling_ignored_during_execution.pod_affinity_term.label_selector.match_labels don't match any label on template metadata", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	object.get(affinity, "pod_anti_affinity", "undefined") != "undefined"

	podAntiAffinity := affinity.pod_anti_affinity

	object.get(podAntiAffinity, "required_during_scheduling_ignored_during_execution", "undefined") != "undefined"

	pref := podAntiAffinity.required_during_scheduling_ignored_during_execution

	object.get(pref, "topology_key", "undefined") != "kubernetes.io/hostname"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution[%d].topology_key is set and is 'kubernetes.io/hostname'", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution[%d].topology_key is invalid or undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 2

	affinity := resource.spec.template.spec.affinity
	object.get(affinity, "pod_anti_affinity", "undefined") != "undefined"

	podAntiAffinity := affinity.pod_anti_affinity

	object.get(podAntiAffinity, "required_during_scheduling_ignored_during_execution", "undefined") != "undefined"

	pref := podAntiAffinity.required_during_scheduling_ignored_during_execution

	object.get(pref, "topology_key", "undefined") == "kubernetes.io/hostname"

	templateLabels := resource.spec.template.metadata.labels
	selectorLabels := pref.label_selector.match_labels

	match_labels(templateLabels, selectorLabels) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution.label_selector.match_labels match any label on template metadata", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.template.spec.affinity.pod_anti_affinity.required_during_scheduling_ignored_during_execution.label_selector.match_labels don't match any label on template metadata", [name]),
	}
}

match_labels(templateLabels, selectorLabels) {
	some Key
	templateLabels[Key] == selectorLabels[Key]
} else = false {
	true
}
