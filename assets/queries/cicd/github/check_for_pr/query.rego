package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	input.document[i].on.pull_request_target


	result := {
		"documentId": input.document[i].id,
		"searchKey": "pull_request_target",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "has pull request trigger",
		"keyActualValue": "does not have a pull request trigger",
	}
}
