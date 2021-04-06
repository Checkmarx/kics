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
		"searchKey": sprintf("%s[%s].spec.container", [resourceType, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.container.readiness_probe is set", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].spec.containter.readiness_probe is undefined", [resourceType, name]),
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
		"searchKey": sprintf("%s[%s].spec.container", [resourceType, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.container[%d].readiness_probe is set", [resourceType, name, y]),
		"keyActualValue": sprintf("%s[%s].spec.containter[%d].readiness_probe is undefined", [resourceType, name, y]),
	}
}

resourceEqual(type) {
	resources := {"kubernetes_cron_job", "kubernetes_job"}

	type == resources[_]
}
