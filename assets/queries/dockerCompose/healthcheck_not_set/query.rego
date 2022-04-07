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
		"keyExpectedValue": "Healthcheck to be defined.",
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
		"keyExpectedValue": "Healthcheck to be enabled.",
		"keyActualValue": "Healthcheck is disabled.",
		"searchLine": common_lib.build_search_line(["services", name, "healthcheck", "disabled"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    hcheck := service_parameters.healthcheck
    check_h_parameters(hcheck)
    
	result := {
    	"debug": sprintf("%s", [hcheck]),
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.healthcheck",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Healthcheck to be enabled and interval, timeout and retries to be defined.",
		"keyActualValue": "Healthcheck doesnt have necessary parameters.",
		"searchLine": common_lib.build_search_line(["services", name, "healthcheck"], []),
	}
}

check_h_parameters(hcheck)
{
    not common_lib.valid_key(hcheck,"interval")
}else{
    not common_lib.valid_key(hcheck,"timeout")
}else{
    not common_lib.valid_key(hcheck,"retries")
}
