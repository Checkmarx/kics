package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    pid := service_parameters.pid
    pid == "host"

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.pid",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be pid mode declared as host",
		"keyActualValue": "There is a pid mode declared as host",
		"searchLine": common_lib.build_search_line(["services", name, "pid"], []),
	}
}
