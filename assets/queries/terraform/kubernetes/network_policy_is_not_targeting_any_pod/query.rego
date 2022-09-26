package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_network_policy[name]

	common_lib.valid_key(resource.spec.pod_selector, "match_labels")

	targetLabels := resource.spec.pod_selector.match_labels
	labelValue := targetLabels[key]

	not hasReference(labelValue)

	not findTargettedPod(labelValue, key)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_network_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_network_policy[%s].spec.pod_selector.match_labels", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_network_policy[%s].spec.pod_selector.match_labels is targeting at least a pod", [name]),
		"keyActualValue": sprintf("kubernetes_network_policy[%s].spec.pod_selector.match_labels is not targeting any pod", [name]),
	}
}

findTargettedPod(lValue, lKey) {
	pod := input.document[_].resource[resourceType]
	resourceType != "kubernetes_network_policy"
	labels := pod[podName].metadata.labels

	some key
	key == lKey
	labels[key] == lValue
} else = false {
	true
}

hasReference(label) {
	regex.match("kubernetes_[_a-zA-Z]+.[a-zA-Z-_0-9]+", label)
}
