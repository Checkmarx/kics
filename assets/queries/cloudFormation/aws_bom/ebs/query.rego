package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	ebs_volume := document[i].Resources[name]
	ebs_volume.Type == "AWS::EC2::Volume"

	bom_output = {
		"resource_type": "AWS::EC2::Volume",
		"resource_name": cf_lib.get_resource_name(ebs_volume, name),
		"resource_accessibility": "unknown",
		"resource_encryption": cf_lib.get_encryption(ebs_volume),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
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
