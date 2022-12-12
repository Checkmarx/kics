package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    network_mode := service_parameters.network_mode
    network_mode == "host"

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.network_mode",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be network mode declared as host",
		"keyActualValue": "There is a network mode declared as host",
		"searchLine": common_lib.build_search_line(["services", name, "network_mode"], []),
	}
}
