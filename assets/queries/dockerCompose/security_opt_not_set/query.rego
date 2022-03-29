package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]	
    not common_lib.valid_key(service_parameters, "security_opt")
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Docker compose file to have 'security_opt' attribute",
		"keyActualValue": "Docker compose file does not have 'security_opt' attribute",
		"searchLine": common_lib.build_search_line(["services", name], [])
	}
}

#security_opt gets ignored when using docker in swarm mode (https://docs.docker.com/engine/swarm/), 
#which enables the user to manage several docker engines at once
#a docker engine (https://docs.docker.com/engine/) is an instance of docker installed in a host
