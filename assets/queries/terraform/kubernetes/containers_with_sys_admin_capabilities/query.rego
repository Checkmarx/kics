package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers)
	containers[y].security_context.capabilities.add[_] = "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.add should not have 'SYS_ADMIN'", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.add has 'SYS_ADMIN'", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], y, "security_context", "capabilities", "add"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers)
	containers.security_context.capabilities.add[_] = "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.security_context.capabilities.add", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities.add should not have 'SYS_ADMIN'", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.capabilities.add has 'SYS_ADMIN'", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line(array.concat(["resource", resourceType, name], split(specInfo.path, ".")), [types[x], "security_context", "capabilities", "add"]),
	}
}
