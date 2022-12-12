package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "networks")

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("There should be a network declared for the service '%s'", [name]),
		"keyActualValue": sprintf("There is no network declared for the service '%s'", [name]),
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
