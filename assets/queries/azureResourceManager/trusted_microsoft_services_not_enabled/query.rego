package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

	value.properties.networkAcls.defaultAction != "Allow"
	not contains_azure_service(value.properties.networkAcls.bypass)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties.networkAcls", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has 'Trusted Microsoft Services' enabled",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'Trusted Microsoft Services' enabled",
		"searchLine": common_lib.build_search_line(path, ["properties", "networkAcls"]),
	}
}

contains_azure_service(bypass) {
	values := split(bypass, ",")
	common_lib.inArray(values, "AzureServices")
}
