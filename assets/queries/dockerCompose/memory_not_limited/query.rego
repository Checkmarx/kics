package Cx

import data.generic.common as common_lib

#FOR VERSION 3
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
   	limits := service_parameters.deploy.resources.limits
    not common_lib.valid_key(limits, "memory")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy.resources.limits",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There is a memory limit in deployed resources",
		"keyActualValue": "There is no memory limit in deployed resources",
		"searchLine": common_lib.build_search_line(["services", name, "deploy", "resources", "limits"], []),
	}
}

#FOR VERSION 2
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) < 3
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "mem_limit")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "For mem_limit to be declared.",
		"keyActualValue": "There is no mem_limit declared.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
