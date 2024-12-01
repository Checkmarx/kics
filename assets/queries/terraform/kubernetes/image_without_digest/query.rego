package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

types := {"init_container", "container"}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	some containerTypes in containers

	not common_lib.valid_key(containerTypes, "image")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].image should be set", [resourceType, name, specInfo.path, types[x], containerTypes]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].image is undefined", [resourceType, name, specInfo.path, types[x], containerTypes]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	image := containers[y].image
	not contains(image, "@")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].image has '@'", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].image does not have '@'", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	not common_lib.valid_key(containers, "image")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.image should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.image is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	image := containers.image
	not contains(image, "@")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.image", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.image has '@'", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.image does not have '@'", [resourceType, name, specInfo.path, types[x]]),
	}
}
