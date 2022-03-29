package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	efs_file_system := document[i].Resources[name]
	efs_file_system.Type == "AWS::EFS::FileSystem"

	bom_output = {
		"resource_type": "AWS::EFS::FileSystem",
		"resource_name": common_lib.get_tag_name_if_exists(efs_file_system),
		"resource_accessibility": "TO DO",
		"resource_encryption": get_encryption(efs_file_system),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"policy": "TO DO",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(bom_output),
	}
}

get_encryption(ebs_volume) = encryption {
	ebs_volume.Properties.Encrypted == true
    encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
