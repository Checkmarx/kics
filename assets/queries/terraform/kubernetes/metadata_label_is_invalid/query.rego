package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	labels := resource[name].metadata.labels

	regex.match("^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$", labels[key]) == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].metadata.labels", [resourceType, name]),
        "searchValue": key,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].metada.labels[%s] has valid label", [resourceType, name, key]),
		"keyActualValue": sprintf("%s[%s].metada.labels[%s] has invalid label", [resourceType, name, key]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "metadata"], ["labels"]),
	}
}
