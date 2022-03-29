package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]	
    privileged := service_parameters.privileged    
 	privileged == true
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.privileged",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'privileged' attribute set to false or not set",
		"keyActualValue": "Docker compose file has 'privileged' attribute as true",
		"searchLine":  common_lib.build_search_line(["services", name, "privileged"], []),
	}
}
