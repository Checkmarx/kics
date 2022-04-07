package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "healthcheck")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Healthcheck to be defined.",
		"keyActualValue": "Healthcheck is not defined.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
