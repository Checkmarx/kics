package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containerLimits := containers[y].resources.limits

	not common_lib.valid_key(containerLimits, "memory")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s[%d].resources", [resourceType, name, specInfo.path, types[x], y]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.limits.memory should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.limits.memory is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x], y], ["resources"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)

	not common_lib.valid_key(containers.resources.limits, "memory")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.resources.limits", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.limits.memory should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.limits.memory is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x]], ["resources", "limits"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containersType := containers[y]

	not common_lib.valid_key(containersType, "resources")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s[%d]", [resourceType, name, specInfo.path, types[x], y]),
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
	containersType := containers[y]

	not common_lib.valid_key(containersType.resources, "limits")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s[%d].resources", [resourceType, name, specInfo.path, types[x], y]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].resources.limits should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].resources.limits is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x], y], ["resources"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)

	not common_lib.valid_key(containers.resources, "limits")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.resources", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.resources.limits should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.resources.limits is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, specInfo.path, types[x]], ["resources"]),
	}
}
