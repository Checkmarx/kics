package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	not resource_equal(resourceType)

	specInfo := tf_lib.getSpecInfo(resource[name])
	container := specInfo.spec[types[x]]

	is_object(container) == true

	not common_lib.valid_key(container, "readiness_probe")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.readiness_probe should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.readiness_probe is undefined", [resourceType, name, specInfo.path, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	not resource_equal(resourceType)

	specInfo := tf_lib.getSpecInfo(resource[name])
	container := specInfo.spec[types[x]]

	is_array(container) == true
	containersType := container[_]

	not common_lib.valid_key(containersType, "readiness_probe")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].readiness_probe should be set", [resourceType, name, specInfo.path, types[x], containersType]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].readiness_probe is undefined", [resourceType, name, specInfo.path, types[x], containersType]),
	}
}

resource_equal(type) {
	resources := {"kubernetes_cron_job", "kubernetes_job"}

	type == resources[_]
}
