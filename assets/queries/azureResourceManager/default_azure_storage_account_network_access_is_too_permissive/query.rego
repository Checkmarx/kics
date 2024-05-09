package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

	res1 := publicNetworkAccessEnabled(value.properties)
    res2 := aclsDefaultActionAllow(value.properties)

    issue := prepare_issue(res1, res2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
        "searchLine": common_lib.build_search_line(path, issue.sl),
		"issueType": issue.issueType,
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' publicNetworkAccess should be set to false, and/or networkAcls.defaultAction should be set to deny",
		"keyActualValue": issue.kav,
	}
}

publicNetworkAccessEnabled(properties) = reason {
	not properties.publicNetworkAccess
    reason := "not defined"
} else = reason {
	properties.publicNetworkAccess
	lower(properties.publicNetworkAccess) == "enabled"
    reason := "enabled"
}

aclsDefaultActionAllow(properties) = reason {
	not properties.networkAcls.defaultAction
    reason := "not defined"
} else = reason {
	properties.networkAcls.defaultAction
    lower(properties.networkAcls.defaultAction) == "allow"
    reason := "allow"
}

prepare_issue(val1, val2) = issue {
	val1 == "not defined"
    val2 == "not defined"
    issue := {
    	"kav": "resource with type 'Microsoft.Storage/storageAccounts' publicNetworkAccess is not set (default is 'Enabled')",
        "sk": ".properties.publicNetworkAccess",
        "sl": ["properties"],
        "issueType": "MissingAttribute"
    }
} else = issue {
	val1 == "enabled"
    issue := {
    	"kav": "resource with type 'Microsoft.Storage/storageAccounts' publicNetworkAccess is set to 'Enabled')",
        "sk": ".properties.publicNetworkAccess",
        "sl": ["properties", "publicNetworkAccess"],
        "issueType": "IncorrectValue"
    }
} else = issue {
    val2 == "allow"
    issue := {
    	"kav": "resource with type 'Microsoft.Storage/storageAccounts' networkAcls.defaultAction is set to 'Allow')",
        "sk": ".properties.networkAcls.defaultAction",
        "sl": ["properties", "networkAcls", "defaultAction"],
        "issueType": "IncorrectValue"
    }
}