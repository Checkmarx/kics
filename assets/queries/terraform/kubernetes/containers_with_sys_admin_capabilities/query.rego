package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true
	containers[y].security_context.capabilities.add[_] = "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s[%d].security_context.capabilities.add does not have 'SYS_ADMIN'", [name, types[x], y]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s[%d].security_context.capabilities.add has 'SYS_ADMIN'", [name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true
	containers.security_context.capabilities.add[_] = "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s.security_context.capabilities.add", [name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s.security_context.capabilities.add does not have 'SYS_ADMIN'", [name, types[x]]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s.security_context.capabilities.add has 'SYS_ADMIN'", [name, types[x]]),
	}
}
