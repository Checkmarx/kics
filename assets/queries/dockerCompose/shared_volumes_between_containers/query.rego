package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	volumes_shared := resource.volumes
	_:= volumes_shared[v1]
	service_parameters := resource.services[name]
    volumes := service_parameters.volumes
    volume2 := volumes[v2]
	startswith(volume2, v1)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be volumes created and shared between containers",
		"keyActualValue": sprintf("Volume %s created and shared between containers", [v1]),
		"searchLine": common_lib.build_search_line(["services", name, "volumes", v2], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    volumes := service_parameters.volumes
    volume := volumes[v]
    
    dup(resource, name, volume)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be volumes shared between containers",
		"keyActualValue": sprintf("Volume %s shared between containers", [volume]),
		"searchLine": common_lib.build_search_line(["services", name, "volumes", v], []),
	}
}

dup(resource, resource_name, volume_name){
	service_parameters := resource.services[name]
    name != resource_name
    volumes := service_parameters.volumes
    vname := volumes[_]
    vname == volume_name
}