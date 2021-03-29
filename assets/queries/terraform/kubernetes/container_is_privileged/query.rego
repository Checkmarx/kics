package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true
	containers[y].security_context.privileged == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].security_context.privileged is set to false", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].security_context.privileged is set to true", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true
	containers.security_context.privileged == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.security_context.privileged", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.security_context.privileged is not set to true", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.security_context.privileged is set to true", [resourceType, name, types[x]]),
	}
}
