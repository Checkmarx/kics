package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	object.get(document, "kind", "undefined") == "NetworkPolicy"

	targetLabels := document.spec.podSelector.matchLabels
	count(targetLabels) > 0
	not targetsAnyPod(targetLabels)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.podSelector.matchLabels", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.podSelector.matchLabels' is targeting at least one pod that matches all labels",
		"keyActualValue": "'spec.podSelector.matchLabels' is not targeting any pod that matches all labels",
	}
}

# Kubernetes label selectors combine their entries with AND semantics,
# so a pod is only selected when it carries every key/value pair of
# spec.podSelector.matchLabels at once. Checking each entry independently
# would let different pods satisfy different parts of the selector.
targetsAnyPod(targetLabels) {
	pod := input.document[_]
	object.get(pod, "kind", "undefined") != "NetworkPolicy"
	labels := pod.metadata.labels

	not missingLabel(targetLabels, labels)
}

missingLabel(targetLabels, labels) {
	some key
	value := targetLabels[key]
	not labels[key] == value
}
