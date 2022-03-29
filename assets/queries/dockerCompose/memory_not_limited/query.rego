package Cx

import data.generic.common as common_lib

#FOR VERSION 3
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
   	limits := service_parameters.deploy.resources.limits
    not common_lib.valid_key(limits, "memory")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy.resources.limits",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'deploy.resources.limits.memory' is defined",
		"keyActualValue": "'deploy.resources.limits.memory' is not defined",
		"searchLine": common_lib.build_search_line(["services", name, "deploy", "resources", "limits"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "deploy")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'deploy.resources.limits.memory' is defined",
		"keyActualValue": "'deploy' is not defined",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters.deploy, "resources")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'deploy.resources.limits.memory' is defined",
		"keyActualValue":  "'deploy.resources' is not defined",
		"searchLine": common_lib.build_search_line(["services", name, "deploy"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
   	resources := service_parameters.deploy.resources
    not common_lib.valid_key(resources, "limits")
   
	result := {
    	"debug":sprintf("%s",[resources]),
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy.resources",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'deploy.resources.limits.memory' is defined",
		"keyActualValue": "'deploy.resources.limits' is defined",
		"searchLine": common_lib.build_search_line(["services", name, "deploy", "resources"], []),
    }
}

#FOR VERSION 2
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) < 3
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "mem_limit")
   
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "For mem_limit to be declared.",
		"keyActualValue": "There is no mem_limit declared.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
