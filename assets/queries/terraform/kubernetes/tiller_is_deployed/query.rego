package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	checkMetadata(resource[name].metadata)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].metadata", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].metadata should not refer any to a Tiller resource", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].metadata refers to a Tiller resource", [resourceType, name]),
	}
}

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true
	some y
	contains(object.get(containers[y], "image", "undefined"), "tiller")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].image shouldn't have any Tiller containers", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].image contains a Tiller container", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true
	contains(object.get(containers, "image", "undefined"), "tiller")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.%s.image", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.image shouldn't have any Tiller containers", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.image contains a Tiller container", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec

	checkMetadata(spec.template.metadata)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.metadata", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.template.metadata should not refer to any Tiller resource", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].spec.template.metadata does not refer to any Tiller resource", [resourceType, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec.template.spec
	containers := spec[types[x]]

	is_object(containers) == true

	contains(object.get(containers, "image", "undefined"), "tiller")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.spec.%s.image", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.template.spec.%s.image shouldn't have any Tiller containers", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.template.spec.%s.image contains a Tiller container", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec.template.spec
	containers := spec[types[x]]

	is_array(containers) == true

	contains(object.get(containers[y], "image", "undefined"), "tiller")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].spec.template.%s", [resourceType, name, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.template.spec.%s[%d].image shouldn't have any Tiller containers", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.template.spec.%s[%d].image contains a Tiller container", [resourceType, name, types[x], y]),
	}
}

checkMetadata(metadata) {
	contains(metadata.name, "tiller")
}

checkMetadata(metadata) {
	object.get(metadata.labels, "app", "undefined") == "helm"
}

checkMetadata(metadata) {
	contains(object.get(metadata.labels, "name", "undefined"), "tiller")
}
