package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resources := input.document[i].resource["google_project_service"]

	not at_least_one_enabled_cloud_asset(resources, input.document[i])
	resource := resources[name]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_project_service[%s].service", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "At least one 'google_project_service.service' field should contain or be equal to 'cloudasset.googleapis.com'",
		"keyActualValue": "No 'google_project_service.service' field does not contain or equal 'cloudasset.googleapis.com'",
		"searchLine": common_lib.build_search_line(["resource", "google_project_service", name, "service"], [])
	}
}

at_least_one_enabled_cloud_asset(resources, doc) {
	service_includes_cloudasset(resources[y].service, resources[y], doc)
}

service_includes_cloudasset(service, project, doc) {
	service == "cloudasset.googleapis.com"
} else {
	service == "${each.value}"
	contains(project.for_each, "\"cloudasset.googleapis.com\"")
} else {
	service == "${each.value}"
	project.for_each[_] == "cloudasset.googleapis.com"
} else {
	service == "${each.value}"
	regex.match("local\\..+", project.for_each)

	patterns := {"${local.": "" , "}":  "" }
    local_name := strings.replace_n(patterns, project.for_each)   # extracts the variable name

	contains_or_in_set(doc.locals[local_name])
}

contains_or_in_set(local_var) {
	local_var == "cloudasset.googleapis.com"
} else  {
	local_var[_] == "cloudasset.googleapis.com"
} else {
	contains(local_var, "\"cloudasset.googleapis.com\"")
}
