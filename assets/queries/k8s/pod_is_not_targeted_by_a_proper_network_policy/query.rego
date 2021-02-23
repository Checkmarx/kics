package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	object.get(document, "kind", "undefined") != "NetworkPolicy"

	findNetworkPolicy(document.metadata.labels[key], key) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.labels.%s", [metadata.name, key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'metadata.labels.%s' is targeted by a network policy", [key]),
		"keyActualValue": sprintf("'metadata.labels.%s' is not targeted by a network policy", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	object.get(document, "kind", "undefined") != "NetworkPolicy"

	findNetworkPolicy(document.metadata.labels[key], key) == true
	properNetworkPolicy(document.metadata.labels[key], key) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.labels.%s", [metadata.name, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'metadata.labels.%s' is targeted by a proper network policy (covers both ingress and egress)", [key]),
		"keyActualValue": sprintf("'metadata.labels.%s' is not targeted by a proper network policy (does not cover ingress and egress)", [key]),
	}
}

findNetworkPolicy(lValue, lKey) {
	networkPolicy := input.document[_]
	object.get(networkPolicy, "kind", "undefined") == "NetworkPolicy"
	spec := networkPolicy.spec
	some key
	key == lKey
	spec.podSelector.matchLabels[key] == lValue
} else = false {
	true
}

properNetworkPolicy(lValue, lKey) {
	networkPolicy := input.document[_]
	object.get(networkPolicy, "kind", "undefined") == "NetworkPolicy"
	spec := networkPolicy.spec
	some key
	key == lKey
	spec.podSelector.matchLabels[key] == lValue
	properSpec(spec) == true
} else = false {
	true
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
