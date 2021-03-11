package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	https_value := task.azure_rm_webapp.https_only

	not ansLib.isAnsibleTrue(https_value)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_webapp}}.https_only", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{azure_rm_webapp}}.https_only is set to true or 'yes'",
		"keyActualValue": sprintf("{{azure_rm_webapp}}.https_only value is '%s'", [https_value]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	https := task.azure_rm_webapp

	object.get(https, "https_only", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_webapp}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{azure_rm_webapp}}.https_only is defined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{azure_rm_webapp}}.https_only is undefined", [task.name]),
	}
}
