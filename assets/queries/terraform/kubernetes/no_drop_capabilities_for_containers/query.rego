package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

types := {"init_container", "container"}

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

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containerSecurity := containers[y].security_context

	not common_lib.valid_key(containerSecurity, "capabilities")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "security_context"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containerCapabilities := containers[y].security_context.capabilities

	not common_lib.valid_key(containerCapabilities, "drop")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.drop should be set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.drop is undefined", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "security_context", "capabilities"]),
	}
}

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

	is_object(containers)
	not common_lib.valid_key(containers.security_context, "capabilities")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.security_context", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.capabilities is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "security_context"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)
	not common_lib.valid_key(containers.security_context.capabilities, "drop")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.security_context.capabilities", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities.drop should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.capabilities.drop is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "security_context", "capabilities"]),
	}
}
