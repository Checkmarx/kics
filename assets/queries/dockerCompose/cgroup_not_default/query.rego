package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
    common_lib.valid_key(service_parameters, "cgroup_parent")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.cgroup_parent",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Cgroup_parent should be undefined",
		"keyActualValue": "Cgroup_parent is defined. Only use this when strictly required.",
		"searchLine": common_lib.build_search_line(["services", name, "cgroup_parent"], []),
	}
}
