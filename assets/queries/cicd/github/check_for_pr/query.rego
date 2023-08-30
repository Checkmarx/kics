package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	uses = input.document[i].jobs[j].steps[k].uses[u]
	not isAllowed(uses)
	not isPinned(uses)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("uses: %s", input.document[i].jobs[j].steps[k].uses[u]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "has pull request trigger",
		"keyActualValue": "does not have a pull request trigger",
	}
}


isAllowed(use){
	allowed := ["actions/"]
    startswith(use,allowed[i])
}

isPinned(use){
	re_match("@[a-f0-9]{40}$", use)
}

