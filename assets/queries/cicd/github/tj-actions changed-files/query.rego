package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	uses := input.document[i].jobs[j].steps[k].uses
	isAllowed(uses)

	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("uses={{%s}}", [uses]),
		"issueType": "InscureAction",
		"keyExpectedValue": "tj-actions changed-files through 46.",
		"keyActualValue": "tj-actions changed-files through 45.",
		"searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "uses"],[])
	}
}


isAllowed(use){
	allowed := ["tj-actions/changed-files@v45"]
    startswith(use,allowed[i])
}

