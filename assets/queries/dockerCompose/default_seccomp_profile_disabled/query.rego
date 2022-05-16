package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    sec_opt_array := service_parameters.security_opt
    sec_opt := sec_opt_array[a]
    contains(sec_opt,"seccomp:unconfined")
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.security_opt",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Seccomp default profile to not be disabled.",
		"keyActualValue": "Seccomp default profile is disabled.",
		"searchLine": common_lib.build_search_line(["services", name, "security_opt", a], []),
	}
}
