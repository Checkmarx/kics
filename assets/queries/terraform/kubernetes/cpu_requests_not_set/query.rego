package Cx

import data.generic.terraform as terraLib
import data.generic.common as common_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	requestedContainers := containers[y].resources.requests

	not common_lib.valid_key(requestedContainers, "cpu")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.requests.cpu is set", [resourceType, name, specInfo.path, types[x], requestedContainers]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.requests.cpu is undefined", [resourceType, name, specInfo.path, types[x], requestedContainers]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	not common_lib.valid_key(containers.resources.requests, "cpu")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.resources.requests", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.requests.cpu is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.requests.cpu is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	containerTypes := containers[_]

	not common_lib.valid_key(containerTypes, "resources")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources is set", [resourceType, name, specInfo.path, types[x], containerTypes]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources is undefined", [resourceType, name, specInfo.path, types[x], containerTypes]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	not common_lib.valid_key(containers, "resources")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	requestedContainers := containers[y].resources

	not common_lib.valid_key(requestedContainers, "requests")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.requests is set", [resourceType, name, specInfo.path, types[x], requestedContainers]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.requests is undefined", [resourceType, name, specInfo.path, types[x], requestedContainers]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	not common_lib.valid_key(containers.resources, "requests")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.resources", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.requests is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.requests is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}
