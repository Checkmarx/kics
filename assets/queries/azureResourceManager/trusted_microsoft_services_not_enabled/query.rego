package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	#case of the path /properties/networkAcls/defaultAction_or_bypass not existing
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

    variable_path := path_check(value)
	variable_path != "there_is_complete_path"
	raw_split = split(variable_path,".")
	searchLine_vars := [split | split := raw_split[_]; split != ""]


	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": "value.name",
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, variable_path]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' should have 'Trusted Microsoft Services' enabled",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'Trusted Microsoft Services' enabled",
		"searchLine": common_lib.build_search_line(path, searchLine_vars),
	}
}

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

path_check(resource) = "" {
  	not common_lib.valid_key(resource,"properties")
  } else = ".properties" {
  	resource.properties == {} 
  } else = ".properties" {
  	not common_lib.valid_key(resource.properties,"networkAcls")
  } else = "there_is_complete_path" {
	common_lib.valid_key(resource.properties.networkAcls,"defaultAction")
  } else = "there_is_complete_path" {
	common_lib.valid_key(resource.properties.networkAcls,"bypass")
  } else = ".properties.networkAcls"
