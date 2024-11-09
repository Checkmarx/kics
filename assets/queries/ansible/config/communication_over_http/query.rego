package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	galaxyGroup := doc.groups.galaxy

	url := galaxyGroup.server
	startswith(url, "http://")

	result := {
		"documentId": doc.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "[galaxy].server",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'server' from galaxy group should be accessed via the HTTPS protocol",
		"keyActualValue": "'server' from galaxy group is accessed via the HTTP protocol'",
	}
}
