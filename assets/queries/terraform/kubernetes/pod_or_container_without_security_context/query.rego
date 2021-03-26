package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec

	object.get(spec, "security_context", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.security_context is set", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.security_context is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true
	object.get(containers, "security_context", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s.security_context is set", [name, types[x]]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s.security_context is undefined", [name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true
	object.get(containers[y], "security_context", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s[%d].security_context is set", [name, types[x], y]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s[%d].security_context is undefined", [name, types[x], y]),
	}
}
