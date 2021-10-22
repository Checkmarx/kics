package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	aws_msk_cluster_resource := input.document[i].resource.aws_msk_cluster[name]

	bom_output = {
		"resource_type": "aws_msk_cluster",
		"resource_name": aws_msk_cluster_resource.cluster_name,
		# TODO: need to check MSK policy
		"resource_accessibility": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "Queues",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_msk_cluster_resource[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_msk_cluster_resource", name], []),
		"value": json.marshal(bom_output),
	}
}
