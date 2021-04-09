package Cx

import data.generic.terraform as terraLib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType][name]

	specInfo := terraLib.getSpecInfo(resource[name])

	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	has_secret_key_ref(containers[y])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].env.value_from.secret_key_ref is undefined", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].env.value_from.secret_key_ref is set", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])

	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	has_secret_key_ref(containers)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.env", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.env.value_from.secret_key_ref is undefined", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.env.value_from.secret_key_ref is set", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])

	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	has_secret_key_ref(containers[y])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].env_from.secret_ref is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].env_from.secret_ref is set", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])

	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	has_secret_key_ref(containers)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.env_from", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.env_from.secret_ref is undefined", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.env_from.secret_ref is set", [resourceType, name, specInfo.path, types[x]]),
	}
}

has_secret_key_ref(container) {
	is_array(container.env) == true

	object.get(container.env[x].value_from, "secret_key_ref", "undefined") != "undefined"
}

has_secret_key_ref(container) {
	is_object(container.env) == true

	object.get(container.env.value_from, "secret_key_ref", "undefined") != "undefined"
}

has_secret_key_ref(container) {
	is_array(container.env) == true

	object.get(container.env_from, "secret_ref", "undefined") != "undefined"
}

has_secret_key_ref(container) {
	is_object(container.env) == true

	object.get(container.env_from, "secret_ref", "undefined") != "undefined"
}
