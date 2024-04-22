package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	uses := input.document[i].jobs[j].steps[k].uses
	not isAllowed(uses)
	not isPinned(uses)
	not isRelative(uses)
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("uses={{%s}}", [uses]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Action pinned to a full length commit SHA.",
		"keyActualValue": "Action is not pinned to a full length commit SHA.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "uses"],[])
	}
}


isAllowed(use){
	allowed := ["actions/"]
    startswith(use,allowed[i])
}

isPinned(use){
	regex.match("@[a-f0-9]{40}$", use)
}

isRelative(use){
	allowed := ["./"]
    startswith(use,allowed[i])
}

