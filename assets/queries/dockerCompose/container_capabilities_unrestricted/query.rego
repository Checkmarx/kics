package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]	
    common_lib.valid_key(service_parameters, "cap_add")
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.cap_add",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Make sure you only add the necessary capabilities to your container.",
		"keyActualValue": "Docker compose file has 'cap_add' attribute.",
		"searchLine": common_lib.build_search_line(["services", name, "cap_add"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]	
    not common_lib.valid_key(service_parameters, "cap_drop")
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Docker compose file to have 'cap_drop' attribute",
		"keyActualValue": "Docker compose file doesn't have 'cap_drop' attribute. Make sure your container only has necessary capabilities.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
