package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some resource in input.document
	service_parameters := resource.services[name]
	volumes := service_parameters.volumes
	volume := volumes[v]
	path := split(volume, ":")
	host_path := path[0]
	common_lib.isOSDir(host_path)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be sensitive directory mounted as a volume",
		"keyActualValue": sprintf("There is a sensitive directory (%s) mounted as a volume", [host_path]),
		"searchLine": common_lib.build_search_line(["services", name, "volumes", v], []),
	}
}

CxPolicy[result] {
	some resource in input.document
	service_parameters := resource.services[name]
	volumes := service_parameters.volumes
	volume := volumes[v]
	host_path := volume.source
	common_lib.isOSDir(host_path)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.volumes.source", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be sensitive directory mounted as a volume",
		"keyActualValue": sprintf("There is a sensitive directory (%s) mounted as a volume", [host_path]),
		"searchLine": common_lib.build_search_line(["services", name, "volumes", v, "source"], []),
	}
}

CxPolicy[result] {
	some resource in input.document
	volume := resource.volumes[name]
	host_path := volume.driver_opts.device
	common_lib.isOSDir(host_path)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("volumes.%s.driver_opts.device", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be sensitive directory mounted as a volume",
		"keyActualValue": sprintf("There is a sensitive directory (%s) mounted as a volume", [host_path]),
		"searchLine": common_lib.build_search_line(["volumes", name, "driver_opts", "device"], []),
	}
}

CxPolicy[result] {
	some resource in input.document
	volume := resource.volumes[name]
	host_path := volume.driver_opts.mountpoint
	common_lib.isOSDir(host_path)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("volumes.%s.driver_opts.mountpoint", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There shouldn't be sensitive directory mounted as a volume",
		"keyActualValue": sprintf("There is a sensitive directory (%s) mounted as a volume", [host_path]),
		"searchLine": common_lib.build_search_line(["volumes", name, "driver_opts", "mountpoint"], []),
	}
}
