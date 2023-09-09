package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    volumes := service_parameters.volumes
    volume := volumes[v]
    startswith(volume, "shared-volume:")

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be volumes shared between containers",
		"keyActualValue": sprintf("There is a volume shared (%s) between containers", [volume]),
		"searchLine": common_lib.build_search_line(["services", name, "volumes", v], []),
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
		"keyActualValue": sprintf("There is a volume shared (%s) between containers", [volume]),
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