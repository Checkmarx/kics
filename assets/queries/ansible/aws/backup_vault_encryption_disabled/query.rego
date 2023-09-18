package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.backup_vault"}
	vault := task[modules[m]]
	ansLib.checkState(vault)

	not commonLib.valid_key(vault, "encryption_key_arn")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.backup_vault.enable_logging should be defined",
		"keyActualValue": "amazon.aws.backup_vault.enable_logging is undefined",
	}
}
