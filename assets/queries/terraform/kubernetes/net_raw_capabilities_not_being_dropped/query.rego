package Cx

import data.generic.terraform as terraLib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	object.get(containers[y].security_context.capabilities, "drop", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.drop is set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("k%s[%s].%s.%s[%d].security_context.capabilities.drop is undefined", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	options := {"ALL", "NET_RAW"}

	dropList := containers[y].security_context.capabilities.drop
	not drop(dropList, options)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.drop is ALL or NET_RAW", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities.add is not ALL or NET_RAW", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	object.get(containers[y].security_context, "capabilities", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities is set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.capabilities is undefined", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	object.get(containers[y], "security_context", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context is set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context is undefined", [resourceType, name, specInfo.path, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	object.get(containers.security_context.capabilities, "drop", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.security_context.capabilities", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities.drop is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.capabilities.drop is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	options := {"ALL", "NET_RAW"}

	not drop(containers.security_context.capabilities.drop, options)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.security_context.capabilities.drop", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities.drop is ALL or NET_RAW", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.capabilities.drop is not ALL or NET_RAW", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	object.get(containers.security_context, "capabilities", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s.security_context", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.capabilities is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.capabilities is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	object.get(containers, "security_context", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

drop(array, elem) {
	upper(array[_]) == elem[_]
}
