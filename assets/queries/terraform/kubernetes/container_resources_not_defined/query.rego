package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true
	object.get(containers[y], "resources", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s[%d].resources is set", [name, types[x], y]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s[%d].resources is undefined", [name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true
	object.get(containers, "resources", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s.resources is set", [name, types[x]]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s.resources is undefined", [name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_array(containers) == true

	resources := {"limits", "requests"}

	object.get(containers[y].resources, resources[z], "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s", [name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s[%d].resources.%s is set", [name, types[x], y, resources[z]]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s[%d].resources.%s is undefined", [name, types[x], y, resources[z]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
	types := {"init_container", "container"}
	containers := spec[types[x]]

	is_object(containers) == true

	resources := {"limits", "requests"}

	object.get(containers.resources, resources[z], "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.%s.resources", [name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.%s.resources.%s is set", [name, types[x], resources[z]]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.%s.resources.%s is undefined", [name, types[x], resources[z]]),
	}
}
