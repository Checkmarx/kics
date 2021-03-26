package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true
	object.get(containers[y].security_context.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s[%d].security_context.capabilities.add is undefined", [name, types[x], y]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s[%d].security_context.capabilities.add is set", [name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true
	object.get(containers.security_context.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s.security_context.capabilities.add", [name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s.security_context.capabilities.add is undefined", [name, types[x]]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s.security_context.capabilities.add is set", [name, types[x]]),
	}
}
