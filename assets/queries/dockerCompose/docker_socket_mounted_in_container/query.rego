package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    volumes := service_parameters.volumes
    volume := volumes[v]
    path := split(volume,":")
    host_path := path[0]
    contains(host_path, "docker.sock")
 	
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "To not have docker socket named 'docker.sock' mounted in a volume",
		"keyActualValue": "There is a docker socket named 'docker.sock' mounted in a volume",
		"searchLine": common_lib.build_search_line(["services", name, "volumes", v], []),
	}
}
