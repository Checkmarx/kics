package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	aws_msk_cluster_resource := doc.resource.aws_msk_cluster[name]

	bom_output = {
		"resource_type": "aws_msk_cluster",
		"resource_name": aws_msk_cluster_resource.cluster_name,
		"resource_accessibility": get_accessibility(aws_msk_cluster_resource),
		"resource_encryption": common_lib.get_encryption_if_exists(aws_msk_cluster_resource),
		"resource_vendor": "AWS",
		"resource_category": "Streaming",
	}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_msk_cluster[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_msk_cluster_resource", name], []),
		"value": json.marshal(bom_output),
	}
}

get_accessibility(msk) = accessibility {
	msk.broker_node_group_info.connectivity_info.public_access.type == "SERVICE_PROVIDED_EIPS"
	accessibility = "public"
} else = accessibility {
	accessibility = "private"
}
