package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_roledefinition", "azure_rm_roledefinition"}
	roleDefinition := task[modules[m]]
	ans_lib.checkState(roleDefinition)

	actions := roleDefinition.permissions[p].actions

	allows_custom_roles_creation(actions)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.permissions.actions", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.permissions[%d].actions should not allow custom role creation", [modules[m], p]),
		"keyActualValue": sprintf("%s.permissions[%d].actions allows custom role creation", [modules[m], p]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "permissions", p, "actions"], []),
	}
}

customRole := "Microsoft.Authorization/roleDefinitions/write"

allows_custom_roles_creation(actions) {
	count(actions) == 1
	options := {"*", customRole}
	actions[0] == options[x]
} else {
	count(actions) > 1
	actions[x] == customRole
}
