package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "healthcheck")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Healthcheck should be defined.",
		"keyActualValue": "Healthcheck is not defined.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    service_parameters.healthcheck.disable == true
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.healthcheck.disable",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Healthcheck should be enabled.",
		"keyActualValue": "Healthcheck is disabled.",
		"searchLine": common_lib.build_search_line(["services", name, "healthcheck", "disable"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    test := service_parameters.healthcheck.test
    test == ["NONE"]
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.healthcheck.test",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Healthcheck should be enabled.",
		"keyActualValue": "Healthcheck is disabled.",
		"searchLine": common_lib.build_search_line(["services", name, "healthcheck", "test"], []),
	}
}
