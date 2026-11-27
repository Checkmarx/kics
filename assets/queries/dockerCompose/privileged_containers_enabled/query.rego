package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	service_parameters := resource.services[name]
	privileged := service_parameters.privileged
	privileged_enabled(privileged)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'privileged' attribute set to false or not set",
		"keyActualValue": sprintf("Docker compose file has 'privileged' attribute as %v", [privileged]),
		"searchLine": common_lib.build_search_line(["services", name, "privileged"], []),
	}
}

privileged_enabled(value) {
	value == true
}

# Docker Compose (compose-go toBoolean) coerces these strings, case-insensitively and without trimming, to true
privileged_enabled(value) {
	is_string(value)
	truthy_values := {"true", "y", "yes", "on"}
	truthy_values[lower(value)]
}
