package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    sec_opt := service_parameters.security_opt
    not no_new_privileges(sec_opt)
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.security_opt",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "no-new-privileges should be set in security_opt.",
		"keyActualValue": "no-new-privileges is not set in security_opt",
		"searchLine": common_lib.build_search_line(["services", name, "security_opt"], []),
	}
}

no_new_privileges(sec_opt) {
    sec_opt[_] == "no-new-privileges:true"
}
