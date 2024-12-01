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
	containerLimits := containers[y].resources.limits

	not common_lib.valid_key(containerLimits, "memory")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.limits.memory should be set", [resourceType, name, specInfo.path, types[x], containerLimits]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.limits.memory is undefined", [resourceType, name, specInfo.path, types[x], containerLimits]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	not common_lib.valid_key(containers.resources.limits, "memory")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.resources.limits", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.limits.memory should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.limits.memory is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	some containersType in containers

	not common_lib.valid_key(containersType, "resources")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources should be set", [resourceType, name, specInfo.path, types[x], containersType]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources is undefined", [resourceType, name, specInfo.path, types[x], containersType]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	not common_lib.valid_key(containers, "resources")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	some containersType in containers

	not common_lib.valid_key(containersType.resources, "limits")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.limits should be set", [resourceType, name, specInfo.path, types[x], containersType]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.limits is undefined", [resourceType, name, specInfo.path, types[x], containersType]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true

	not common_lib.valid_key(containers.resources, "limits")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.resources", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.limits should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.limits is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}
