package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]	
    ipc := service_parameters.ipc    
 	ipc == "host"
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.privileged",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'ipc' attribute not set to host, or not set",
		"keyActualValue": "Docker compose file has 'ipc' attribute as host",
		"searchLine":  common_lib.build_search_line(["services", name, "ipc"], []),
	}
}
