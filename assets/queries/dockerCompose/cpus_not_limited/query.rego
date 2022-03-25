package Cx

import data.generic.common as common_lib

#FOR VERSION 3
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
   	limits := service_parameters.deploy.resources.limits
    not common_lib.valid_key(limits, "cpus")

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There is a cpu priority defined in deployed resources",
		"keyActualValue": "There is no cpu priority defined in deployed resources",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}

#FOR VERSION 2
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) < 3
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "cpus")

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "For cpus priority to be declared.",
		"keyActualValue": "There is no cpus priority declared.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
