package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	document.kind == "NetworkPolicy"
	spec := document.spec

	not findPod(true)

    result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Pod is defined",
		"keyActualValue": "Pod is undefined"
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	document.kind == "NetworkPolicy"
	spec := document.spec

	isTargeted(spec.podSelector.matchLabels[key], spec)

    result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.podSelector.matchLabels[%s] is targeted by a Pod", [key]),
		"keyActualValue": sprintf("spec.podSelector.matchLabels[%s] is not targeted by a Pod", [key])
	}
}

findPod(empty) {
	document := input.document[_]
    document.kind == "Pod"
}

isTargeted(matchLabels, spec) {
	document := input.document[_]
    document.kind == "Pod"
    labelPod = document.metadata.labels[keyPod]
    matchLabels != labelPod

    properSpec(spec) == false
}

properSpec(spec) {
	object.get(spec, "policyTypes", "undefined") != "undefined"
	spec.policyTypes[_] == "Ingress"
	spec.policyTypes[_] == "Egress"
} else {
	object.get(spec, "policyTypes", "undefined") == "undefined"
	object.get(spec, "egress", "undefined") != "undefined"
	count(spec.egress) > 0
} else = false {
	true
}
