package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_stream[name]

	bom_output = {
		"resource_type": "aws_kinesis_stream",
		"resource_name": tf_lib.get_specific_resource_name(resource, "aws_kinesis_stream", name),
		"resource_accessibility": "unknown",
		"resource_encryption": get_encryption(resource),
		"resource_vendor": "AWS",
		"resource_category": "Streaming",
	}

	final_bom_output = common_lib.get_bom_output(bom_output, "")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kinesis_stream[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_kinesis_stream", name], []),
		"value": json.marshal(final_bom_output),
	}
}



get_encryption(resource) = encryption {
	common_lib.valid_key(resource, "kms_key_id")
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
