package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some resource in input.document
	service_parameters := resource.services[name]
	service_parameters.userns_mode == "host"

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.userns_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'userns_mode' should not be set or not set to host",
		"keyActualValue": "Attribute 'userns_mode' is set to host",
		"searchLine": common_lib.build_search_line(["services", name, "userns_mode"], []),
	}
}
