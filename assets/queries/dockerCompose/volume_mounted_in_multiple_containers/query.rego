package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    volumes := service_parameters.volumes
    volume := volumes[v]
    propagation := volume.bind.propagation
    possibilities := {"shared", "rshared", "slave", "rslave"}
    propagation == possibilities[p]
    
	result := {
    	"debug": sprintf("%s",[propagation]),
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes.bind.propagation",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Volumes are not being mounted in multiple containers",
		"keyActualValue": sprintf("Volumes are being mounted in multiple containers, mode: %s", [possibilities[p]]),
		"searchLine": common_lib.build_search_line(["services", name, "volumes", "bind", "propagation"], []),
	}
}
