package Cx

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	not resourceEqual(resourceType)

	container := resource[name].spec[types[x]]

	is_object(container) == true

	object.get(container, "readiness_probe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.readiness_probe is set", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.readiness_probe is undefined", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	not resourceEqual(resourceType)

	container := resource[name].spec[types[x]]

	is_array(container) == true

	object.get(container[y], "readiness_probe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].readiness_probe is set", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].readiness_probe is undefined", [resourceType, name, types[x], y]),
	}
}

resourceEqual(type) {
	resources := {"kubernetes_cron_job", "kubernetes_job"}

	type == resources[_]
}
