package Cx

import data.generic.common as common_lib

#FOR VERSION 3
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) >= 3
	service_parameters := resource.services[name]
   	limits := service_parameters.deploy.resources.limits
    not common_lib.valid_key(limits, "cpus")

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy.resources.limits",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'deploy.resources.limits.cpus' should be defined",
		"keyActualValue": "'deploy.resources.limits.cpus' is not defined",
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
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'deploy.resources.limits.cpus' should be defined",
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
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'deploy.resources' should be defined",
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
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy.resources",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'deploy.resources.limits' should be defined",
		"keyActualValue": "'deploy.resources.limits' is not defined",
		"searchLine": common_lib.build_search_line(["services", name, "deploy", "resources"], []),
    }
}

#FOR VERSION 2
CxPolicy[result] {
	resource := input.document[i]
    version := resource.version
    to_number(version) < 3
	service_parameters := resource.services[name]
    not common_lib.valid_key(service_parameters, "cpus")

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "For cpus priority should be declared.",
		"keyActualValue": "There is no cpus priority declared.",
		"searchLine": common_lib.build_search_line(["services", name], []),
	}
}
