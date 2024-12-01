package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some resource in input.document
	service_parameters := resource.services[name]
	restart := service_parameters.restart
	splitted := split(restart, ":")
	attempts := splitted[1]
	to_number(attempts) != 5

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.restart", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "on-failure restart attempts should be 5",
		"keyActualValue": "on-failure restart attempts are not 5",
		"searchLine": common_lib.build_search_line(["services", name, "restart"], []),
	}
}

CxPolicy[result] {
	some resource in input.document
	service_parameters := resource.services[name]
	deploy := service_parameters.deploy
	restart_policy := deploy.restart_policy
	restart_policy.condition == "on-failure"
	restart_policy.max_attempts != 5

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.deploy.restart_policy.max_attempts", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "on-failure restart attempts should be 5",
		"keyActualValue": "on-failure restart attempts are not 5",
		"searchLine": common_lib.build_search_line(["services", name, "deploy", "restart_policy", "max_attempts"], []),
	}
}
