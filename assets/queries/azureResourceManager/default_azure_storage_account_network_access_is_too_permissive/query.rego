package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

	res1 := publicNetworkAccessEnabled(doc, value.properties)
    res2 := aclsDefaultActionAllow(doc, value.properties)

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

publicNetworkAccessEnabled(doc, properties) = reason {
	not properties.publicNetworkAccess
    reason := "not defined"
} else = reason {
	common_lib.valid_key(properties, "publicNetworkAccess")
    [publicNetworkAcessFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.publicNetworkAccess)
    is_array(publicNetworkAcessFromParams)
    lower(publicNetworkAcessFromParams[_]) == "enabled"
    reason := "enabled"
} else = reason {
	common_lib.valid_key(properties, "publicNetworkAccess")
    [publicNetworkAcessFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.publicNetworkAccess)
    not is_array(publicNetworkAcessFromParams)
    lower(publicNetworkAcessFromParams) == "enabled"
    reason := "enabled"
} else = reason {
	properties.publicNetworkAccess
    not arm_lib.isParameterReference(properties.publicNetworkAccess)
	lower(properties.publicNetworkAccess) == "enabled"
    reason := "enabled"
}

aclsDefaultActionAllow(doc, properties) = reason {
	not common_lib.valid_key(properties, "networkAcls")
    reason := "not defined"
} else = reason {
    common_lib.valid_key(properties, "networkAcls")
    not common_lib.valid_key(properties.networkAcls, "defaultAction")
    not arm_lib.isParameterReference(properties.networkAcls)
    reason := "not defined"
} else = reason {
	common_lib.valid_key(properties, "networkAcls")
    [networkAclsFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.networkAcls)
    is_array(networkAclsFromParams)
    lower(networkAclsFromParams[_].defaultAction) == "allow"
    reason := "allow"
} else = reason {
	common_lib.valid_key(properties, "networkAcls")
    [networkAclsFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.networkAcls)
    not is_array(networkAclsFromParams)
    lower(networkAclsFromParams.defaultAction) == "allow"
    reason := "allow"
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
        "sk": ".properties.networkAcls",
        "sl": ["properties", "networkAcls"],
        "issueType": "IncorrectValue"
    }
}