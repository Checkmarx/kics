package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	project := input.document[i].resource.google_project[name]
	project.auto_create_network == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_project[%s].auto_create_network", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project[%s].auto_create_network is false", [name]),
		"keyActualValue": sprintf("google_project[%s].auto_create_network is true", [name]),
	}
}

CxPolicy[result] {
	project := input.document[i].resource.google_project[name]
	not common_lib.valid_key(project, "auto_create_network")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_project[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_project[%s].auto_create_network is false", [name]),
		"keyActualValue": sprintf("google_project[%s].auto_create_network is undefined", [name]),
	}
}
