package Cx

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true
	object.get(containers[y], "image", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].image is set", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].image is undefined", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true
	image := containers[y].image
	not contains(image, "@")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].image has '@'", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].image does not have '@'", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true
	object.get(containers, "image", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.image is set", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.image is undefined", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true
	image := containers.image
	not contains(image, "@")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.image", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.image has '@'", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.image does not have '@'", [resourceType, name, types[x]]),
	}
}
