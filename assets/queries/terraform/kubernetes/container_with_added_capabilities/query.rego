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
	common_lib.valid_key(containers[y].security_context.capabilities, "add")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.add should be undefined", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.add is set", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	common_lib.valid_key(containers.security_context.capabilities, "add")

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.security_context.capabilities.add", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities.add should be undefined", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("k%s[%s].%s.%s.security_context.capabilities.add is set", [resourceType, name, specInfo.path, types[x]]),
	}
}
