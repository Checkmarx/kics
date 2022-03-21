package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	
	to_number(resource.version) < 3.0

	result := {
		"documentId": input.document[i].id,
		"searchKey": "services",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Docker compose file to have 'services' attribute",
		"keyActualValue": "Docker compose file does not have 'services' attribute",
	}
}
