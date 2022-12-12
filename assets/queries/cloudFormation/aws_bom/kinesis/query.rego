package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	kinesis := document[i].Resources[name]
	kinesis.Type == "AWS::Kinesis::Stream"

	bom_output = {
		"resource_type": "AWS::Kinesis::Stream",
		"resource_name": cf_lib.get_resource_name(kinesis, name),
		"resource_accessibility": "unknown",
		"resource_encryption": cf_lib.get_encryption(kinesis),
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
