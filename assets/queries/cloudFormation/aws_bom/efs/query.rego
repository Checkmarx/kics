package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	efs_file_system := document[i].Resources[name]
	efs_file_system.Type == "AWS::EFS::FileSystem"

	info := get_resource_accessibility(efs_file_system)

	bom_output = {
		"resource_type": "AWS::EFS::FileSystem",
		"resource_name": cf_lib.get_resource_name(efs_file_system, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(efs_file_system),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_resource_accessibility(resource) = info {
	common_lib.is_allow_effect(resource.Properties.FileSystemPolicy)
	common_lib.any_principal(resource.Properties.FileSystemPolicy)
	info := {"accessibility": "public", "policy": resource.Properties.FileSystemPolicy}
} else = info {
	info := {"accessibility": "hasPolicy", "policy": resource.Properties.FileSystemPolicy}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
}
