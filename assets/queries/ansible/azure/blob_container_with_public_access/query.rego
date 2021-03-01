package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	hasPublicAccess(task.azure_rm_storageblob.public_access)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_storageblob}}.public_access", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageblob.public_access is not set",
		"keyActualValue": "azure_rm_storageblob.public_access is equal to 'blob' or 'container'",
	}
}

hasPublicAccess(access) {
	lower(access) == "blob"
}

hasPublicAccess(access) {
	lower(access) == "container"
}
