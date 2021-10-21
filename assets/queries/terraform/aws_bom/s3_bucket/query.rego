package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	bucket_resource := input.document[i].resource.aws_s3_bucket[name]

	bom_output = {
		"resource_type": "aws_s3_bucket",
		"resource_name": get_bucket_name(bucket_resource),
		# TODO: need to check bucket policy in addition to ACL
		"resource_accessibility": get_bucket_acl(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
		"value": json.marshal(bom_output),
	}
}

get_bucket_name(bucket_resource) = name {
	name := bucket_resource.bucket
} else = name {
	name := "unknown"
}

get_bucket_acl(bucket_resource) = acl {
	acl := bucket_resource.acl
} else = acl {
	acl := "private"
}
