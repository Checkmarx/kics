package Cx

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType][name]

	containers := resource[name].spec[types[x]]

	is_array(containers) == true

	hasSecretKeyRef(containers[y])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s]", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].env.value_from.secret_key_ref is undefined", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].env.value_from.secret_key_ref is set", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	containers := resource[name].spec[types[x]]

	is_object(containers) == true

	hasSecretKeyRef(containers)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.env", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.env.value_from.secret_key_ref is undefined", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.env.value_from.secret_key_ref is set", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	containers := resource[name].spec[types[x]]

	is_array(containers) == true

	hasSecretRef(containers[y])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].env_from.secret_ref is undefined", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].env_from.secret_ref is set", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	containers := resource[name].spec[types[x]]

	is_object(containers) == true

	hasSecretRef(containers)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.env_from", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.env_from.secret_ref is undefined", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.env_from.secret_ref is set", [resourceType, name, types[x]]),
	}
}

hasSecretKeyRef(container) {
	is_array(container.env) == true

	object.get(container.env[x].value_from, "secret_key_ref", "undefined") != "undefined"
}

hasSecretKeyRef(container) {
	is_object(container.env) == true

	object.get(container.env.value_from, "secret_key_ref", "undefined") != "undefined"
}

hasSecretRef(container) {
	is_array(container.env) == true

	object.get(container.env_from, "secret_ref", "undefined") != "undefined"
}

hasSecretRef(container) {
	is_object(container.env) == true

	object.get(container.env_from, "secret_ref", "undefined") != "undefined"
}
