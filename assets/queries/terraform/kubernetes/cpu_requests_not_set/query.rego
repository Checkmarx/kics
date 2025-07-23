package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	requestedContainers := containers[y].resources.requests

	not common_lib.valid_key(requestedContainers, "cpu")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.name={{%s}}.resources.requests", [resourceType, name, specInfo.path, types[x], containers[y].name]),
		"searchValue": sprintf("%d", [y]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.requests.cpu should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.requests.cpu is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x], y], ["resources", "requests"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)

	not common_lib.valid_key(containers.resources.requests, "cpu")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.resources.requests", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.requests.cpu should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.requests.cpu is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x]], ["resources", "requests"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containerTypes := containers[y]

	not common_lib.valid_key(containerTypes, "resources")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.name={{%s}}", [resourceType, name, specInfo.path, types[x], containers[y].name]),
		"searchValue": sprintf("%d", [y]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x], y], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)
	not common_lib.valid_key(containers, "resources")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x]], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	requestedContainers := containers[y].resources

	not common_lib.valid_key(requestedContainers, "requests")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.name={{%s}}.resources", [resourceType, name, specInfo.path, types[x], containers[y].name]),
		"searchValue": sprintf("%d", [y]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.requests should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.requests is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x], y], ["resources"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)

	not common_lib.valid_key(containers.resources, "requests")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.resources", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.requests should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.requests is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x]], ["resources"]),
	}
}
