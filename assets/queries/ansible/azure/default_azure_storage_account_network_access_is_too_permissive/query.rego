package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task[modules[index]]
	ansLib.checkState(storageAccount)

    res1 := publicNetworkAccessEnabled(storageAccount)
    res2 := aclsDefaultActionAllow(storageAccount)

    issue := prepare_issue(res1, res2)

    result := {
		"documentId": id,
		"resourceType": modules[index],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[index]]),
		"issueType": issue.issueType,
		"keyExpectedValue": issue.kev,
		"keyActualValue": issue.kav,
	}
}

publicNetworkAccessEnabled(sa) = reason {
	not sa.public_network_access
	reason := "not defined"
} else = reason {
	sa.public_network_access
	lower(sa.public_network_access) == "enabled"
	reason := "enabled"
}

aclsDefaultActionAllow(sa) = reason {
	not sa.network_acls.default_action
    reason := "not defined"
} else = reason {
	sa.network_acls.default_action
    lower(sa.network_acls.default_action) == "allow"
    reason := "allow"
}

prepare_issue(val1, val2) = issue {
	val1 == "not defined"
    val2 == "not defined"

    issue := {
    	"kav": "azure_rm_storageaccount.public_network_access is not set (default is 'Enabled')",
        "kev": "azure_rm_storageaccount.public_network_access should be set to 'Disabled'",
        "issueType": "MissingAttribute"
    }
} else = issue {
	val1 == "enabled"
    issue := {
    	"kav": "azure_rm_storageaccount.public_network_access is set to 'Enabled'",
        "kev": "azure_rm_storageaccount.public_network_access should be set to 'Disabled'",
        "issueType": "IncorrectValue"
    }
} else = issue {
    val2 == "allow"
    issue := {
    	"kav": "azure_rm_storageaccountnetworkAcls.network_acls.default_action is set to 'Allow'",
    	"kev": "azure_rm_storageaccountnetworkAcls.network_acls.default_action should be set to 'Deny'",
        "issueType": "IncorrectValue"
    }
}