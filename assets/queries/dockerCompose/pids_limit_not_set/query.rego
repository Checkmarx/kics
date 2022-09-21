package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    version := resource.version
    to_number(version) < 3
    not common_lib.valid_key(service_parameters, "pids_limit")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Pids_limit should be defined.",
		"keyActualValue": "Pids_limit is not defined.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    version := resource.version
    to_number(version) < 3
    pids_limit := service_parameters.pids_limit
    pids_limit == -1
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.pids_limit",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Pids_limit should be limited.",
		"keyActualValue": "Pids_limit is not limited.",
		"searchLine": common_lib.build_search_line(["services", name, "pids_limit"], []),
	}
}
