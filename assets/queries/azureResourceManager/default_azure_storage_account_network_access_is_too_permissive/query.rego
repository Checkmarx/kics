package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

	res1 := publicNetworkAccessNotDisabled(doc, value.properties)
    lower(res1) != "disabled"
    res2 := aclsDefaultActionNotDeny(doc, value.properties)
    lower(res2) != "deny"

    issue := prepare_issue(res1, res2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
        "searchLine": common_lib.build_search_line(path, issue.sl),
		"issueType": issue.issueType,
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' publicNetworkAccess should be set to 'Disabled', and/or networkAcls.defaultAction should be set to 'Deny'",
		"keyActualValue": issue.kav,
	}
}

publicNetworkAccessNotDisabled(doc, properties) = reason {
	not properties.publicNetworkAccess
    reason := "not defined"
} else = reason {
	common_lib.valid_key(properties, "publicNetworkAccess")
    [publicNetworkAcessFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.publicNetworkAccess)
    is_array(publicNetworkAcessFromParams)
    reason := publicNetworkAcessFromParams[_]
} else = reason {
	common_lib.valid_key(properties, "publicNetworkAccess")
    [publicNetworkAcessFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.publicNetworkAccess)
    not is_array(publicNetworkAcessFromParams)
    reason := publicNetworkAcessFromParams
} else = reason {
	properties.publicNetworkAccess
    not arm_lib.isParameterReference(properties.publicNetworkAccess)
	reason := properties.publicNetworkAccess
}

aclsDefaultActionNotDeny(doc, properties) = reason {
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
    reason := networkAclsFromParams[_].defaultAction
} else = reason {
	common_lib.valid_key(properties, "networkAcls")
    [networkAclsFromParams, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.networkAcls)
    not is_array(networkAclsFromParams)
    reason := networkAclsFromParams.defaultAction
} else = reason {
	properties.networkAcls.defaultAction
    reason := properties.networkAcls.defaultAction
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
    issue := {
    	"kav": sprintf("resource with type 'Microsoft.Storage/storageAccounts' publicNetworkAccess is set to '%s')", [val1]),
        "sk": ".properties.publicNetworkAccess",
        "sl": ["properties", "publicNetworkAccess"],
        "issueType": "IncorrectValue"
    }
} else = issue {
    issue := {
    	"kav": sprintf("resource with type 'Microsoft.Storage/storageAccounts' networkAcls.defaultAction is set to '%s')", [val2]),
        "sk": ".properties.networkAcls",
        "sl": ["properties", "networkAcls"],
        "issueType": "IncorrectValue"
    }
}