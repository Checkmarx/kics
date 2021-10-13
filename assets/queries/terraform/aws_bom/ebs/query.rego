package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	ebs_volume := input.document[i].resource.aws_ebs_volume[name]

	bom_output = {
		"resource_type": "aws_ebs_volume",
		"resource_name": common_lib.get_tag_name_if_exists(ebs_volume),
		"resource_accessibility": common_lib.get_encryption_if_exists(ebs_volume),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ebs_volume[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_ebs_volume", name], []),
		"value": json.marshal(bom_output),
	}
}
