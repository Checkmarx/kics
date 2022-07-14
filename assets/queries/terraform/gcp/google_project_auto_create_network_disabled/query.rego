package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	project := input.document[i].resource.google_project[name]
	project.auto_create_network == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project",
		"resourceName": tf_lib.get_resource_name(project, name),
		"searchKey": sprintf("google_project[%s].auto_create_network", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project[%s].auto_create_network should be set to false", [name]),
		"keyActualValue": sprintf("google_project[%s].auto_create_network is true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project", name],["auto_create_network"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	project := input.document[i].resource.google_project[name]
	not common_lib.valid_key(project, "auto_create_network")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project",
		"resourceName": tf_lib.get_resource_name(project, name),
		"searchKey": sprintf("google_project[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_project[%s].auto_create_network should be set to false", [name]),
		"keyActualValue": sprintf("google_project[%s].auto_create_network is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project", name],[]),
		"remediation": "auto_create_network = false",
		"remediationType": "addition",
	}
}
