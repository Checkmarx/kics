package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

	[da_val , _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.networkAcls.defaultAction)
	da_val != "Allow"

	[bp_val, bp_val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.networkAcls.bypass)
	not contains_azure_service(bp_val)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.networkAcls", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Storage/storageAccounts' should have 'Trusted Microsoft Services' %s enabled", [bp_val_type]) ,
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'Trusted Microsoft Services' enabled",
		"searchLine": common_lib.build_search_line(path, ["properties", "networkAcls"]),
	}
}

contains_azure_service(bypass) {
	values := split(bypass, ",")
	common_lib.inArray(values, "AzureServices")
}
