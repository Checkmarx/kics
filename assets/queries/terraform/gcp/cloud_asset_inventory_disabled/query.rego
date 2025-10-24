package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource["google_project_service"][name]

	not service_includes_cloudasset(resource.service, resource, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_project_service[%s].service", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_project_service[%s].service' should contain or be equal to 'cloudasset.googleapis.com'", [name]),
		"keyActualValue": sprintf("'google_project_service[%s].service' does not contain or equal 'cloudasset.googleapis.com'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project_service", name, "service"], [])
	}
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
