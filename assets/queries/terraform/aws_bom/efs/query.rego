package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	efs_file_system := input.document[i].resource.aws_efs_file_system[name]

	info := tf_lib.get_accessibility(efs_file_system, name, "aws_efs_file_system_policy", "file_system_id")

	bom_output = {
		"resource_type": "aws_efs_file_system",
		"resource_name": tf_lib.get_resource_name(efs_file_system, name),
		"resource_accessibility": info.accessibility, 
		"resource_encryption": common_lib.get_encryption_if_exists(efs_file_system),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_efs_file_system[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system", name], []),
		"value": json.marshal(final_bom_output),
	}
}
