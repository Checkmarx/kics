package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	spec := resource.spec

	object.get(spec, "host_network", "undefined") == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.host_network", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostNetwork' is false or undefined",
		"keyActualValue": "'spec.hostNetwork' is true",
	}
}
