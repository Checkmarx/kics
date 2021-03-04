package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	object.get(document, "kind", "undefined") == "NetworkPolicy"

	object.get(document.spec, "podSelector", "undefined") != null

	targetLabels := document.spec.podSelector.matchLabels
	findTargettedPod(targetLabels[key], key) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.podSelector.matchLabels.%s", [metadata.name, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.podSelector.matchLabels.%s' is targeting at least a pod", [key]),
		"keyActualValue": sprintf("'spec.podSelector.matchLabels.%s' is not targeting any pod", [key]),
	}
}

findTargettedPod(lValue, lKey) {
	pod := input.document[_]
	object.get(pod, "kind", "undefined") != "NetworkPolicy"
	labels := pod.metadata.labels
	some key
	key == lKey
	labels[key] == lValue
} else = false {
	true
}
