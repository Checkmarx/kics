package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec

	not common_lib.valid_key(spec, "security_context")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.security_context should be set", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.security_context is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod", name, "spec"], []),
	}
}

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)
	not common_lib.valid_key(containers, "security_context")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containersType := containers[y]

	not common_lib.valid_key(containersType, "security_context")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y]),
	}
}
