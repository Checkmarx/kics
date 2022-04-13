package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	msk := document[i].Resources[name]
	msk.Type == "AWS::MSK::Cluster"

	bom_output = {
		"resource_type": "AWS::MSK::Cluster",
		"resource_name": msk.Properties.ClusterName,
		"resource_accessibility": "unknown",
		"resource_encryption": cf_lib.get_encryption(msk),
		"resource_vendor": "AWS",
		"resource_category": "Streaming",
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
