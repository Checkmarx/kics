package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true
	object.get(containers[y].security_context.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].security_context.capabilities.add is undefined", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].security_context.capabilities.add is set", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true
	object.get(containers.security_context.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.security_context.capabilities.add", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.security_context.capabilities.add is undefined", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("k%s[%s].spec.%s.security_context.capabilities.add is set", [resourceType, name, types[x]]),
	}
}
