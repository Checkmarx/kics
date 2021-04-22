package Cx

import data.generic.terraform as terraLib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	not resource_equal(resourceType)

	specInfo := terraLib.getSpecInfo(resource[name])
	container := specInfo.spec[types[x]]

	is_object(container) == true

	object.get(container, "readiness_probe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.readiness_probe is set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.readiness_probe is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	not resource_equal(resourceType)

	specInfo := terraLib.getSpecInfo(resource[name])
	container := specInfo.spec[types[x]]

	is_array(container) == true

	object.get(container[y], "readiness_probe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].readiness_probe is set", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].readiness_probe is undefined", [resourceType, name, specInfo.path, types[x], y]),
	}
}

resource_equal(type) {
	resources := {"kubernetes_cron_job", "kubernetes_job"}

	type == resources[_]
}
