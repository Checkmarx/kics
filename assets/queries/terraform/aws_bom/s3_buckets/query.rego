package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
		"value": json.marshal(bucket),
	}
}
