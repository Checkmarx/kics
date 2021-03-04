package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t].azure_rm_sqlserver

	object.get(task, "ad_user", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_sqlserver}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ad_user' is defined",
		"keyActualValue": "'ad_user' is undefined",
	}
}
