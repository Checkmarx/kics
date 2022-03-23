package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    volumes := service_parameters.volumes
    host_path := split(volumes[0] ,":")
    host_path1 := host_path[1]
 	common_lib.isOSDir(host_path1)
    
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'volumes' attribute not set to a sensitive directory",
		"keyActualValue": "Docker compose file has 'volumes' attribute set to a sensitive directory",
	}
}
