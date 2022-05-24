package Cx

import data.generic.common as common_lib

# same namespace but has no ingress rules
CxPolicy[result] {
	pod := input.document[i]
	pod.kind == "Pod"

    policyList := [policy | policy := input.document[j]; policy.kind == "NetworkPolicy"]
    # if network policies are present
    count(policyList) > 0

    netPolicy = policyList[k]
    isSameNamespace(pod, netPolicy)

    # if no ingress and no egress policies are defined
    not policyHasEgress(netPolicy)
    not policyHasIngress(netPolicy)

    result := {
		"documentId": pod.id,
		"resourceType": pod.kind,
		"resourceName": pod.metadata.name,
		"searchKey": sprintf("metadata.name=%s", [pod.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Pod %s should have ingress and egress rules in matching NetworkPolicy", [pod.metadata.name]),
		"keyActualValue": sprintf("Pod %s has no ingress or egress rules in matching NetworkPolicy", [pod.metadata.name])
	}
}

# if it's not the same namespace pod must be matched explicitly
CxPolicy[result] {
	pod := input.document[i]
	pod.kind == "Pod"

    policyList := [policy | policy := input.document[j]; policy.kind == "NetworkPolicy"]
    # if network policies are present
    count(policyList) > 0

    netPolicy = policyList[k]
    # if it's not in the same namespace there should be a matching labels rule
    not isSameNamespace(pod, netPolicy)

    # if there are matching labels
	pod.metadata.labels[key] == netPolicy.spec.podSelector.matchLabels[key]

    # if no ingress and no egress policies are defined
    not policyHasIngress(netPolicy)
    not policyHasEgress(netPolicy)

    result := {
		"documentId": pod.id,
		"resourceType": pod.kind,
		"resourceName": pod.metadata.name,
		"searchKey": sprintf("metadata.name=%s", [pod.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Pod %s should have ingress and egress rules in matching NetworkPolicy", [pod.metadata.name]),
		"keyActualValue": sprintf("Pod %s has no ingress or egress rules in matching NetworkPolicy", [pod.metadata.name])
	}
}

# if pod and netPolicy are in the same namespace
isSameNamespace(pod, policy) {
	object.get(policy.metadata, "namespace", "default") == object.get(pod.metadata, "namespace", "default")
}

# if policyType array is undefined or policyTypes array contains "Ingress"
policyHasIngress(netPolicy) {
	not common_lib.valid_key(netPolicy.spec, "policyTypes")
} else {
	lower(netPolicy.spec.policyTypes[_]) == lower("Ingress")
}

# if policyType array is undefined and contains egress rules inside the spec
# OR if policyType array contains Egress listed
policyHasEgress(netPolicy) {
	not common_lib.valid_key(netPolicy.spec, "policyTypes")
    count(netPolicy.spec.egress) > 0
} else {
	lower(netPolicy.spec.policyTypes[_]) == lower("Egress")
}
