package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_deployment[name]

	resource.spec.replicas > 1

	common_lib.valid_key(resource.spec.selector, "match_labels")

	targetLabels := resource.spec.selector.match_labels
	labelValue := targetLabels[key]

	not hasReference(labelValue)

	not hasPodDisruptionBudget(labelValue, key)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_deployment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_deployment[%s].spec.selector.match_labels", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_deployment[%s].spec.selector.match_labels is targeted by a PodDisruptionBudget", [name]),
		"keyActualValue": sprintf("kubernetes_deployment[%s].spec.selector.match_labels is not targeted by a PodDisruptionBudget", [name]),
	}
}

hasPodDisruptionBudget(lValue, lKey) {
	pod := input.document[_].resource[resourceType]
	resourceType == "kubernetes_pod_disruption_budget"

	labels := pod[podName].spec.selector.match_labels

	some key
	key == lKey
	labels[key] == lValue
} else = false {
	true
}

hasReference(label) {
	regex.match("kubernetes_pod_disruption_budget.[a-zA-Z-_0-9]+", label)
}
