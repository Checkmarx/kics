package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	bucket_resource := input.document[i].resource.aws_s3_bucket[name]

	bom_output = {
		"resource_type": "aws_s3_bucket",
		"resource_name": get_bucket_name(bucket_resource),
		"resource_accessibility": getAccessibility(bucket_resource, name),
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

is_public_access_blocked(s3BucketPublicAccessBlock) {
	s3BucketPublicAccessBlock.block_public_acls == true
    s3BucketPublicAccessBlock.block_public_policy == true
}

getAccessibility(bucket, bucketName) = accessibility {
	# cases when public access is blocked by aws_s3_bucket_public_access_block
	s3BucketPublicAccessBlock := input.document[i].resource.aws_s3_bucket_public_access_block[_]
	split(s3BucketPublicAccessBlock.bucket, ".")[1] == bucketName
	is_public_access_blocked(s3BucketPublicAccessBlock)
	accessibility := "private"
} else = accessibility {
	# cases when there is a unrestriced policy
	accessibility := terra_lib.getAccessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")
    accessibility != "unknown"   
} else = accessibility {
	# last cases: acl definition
	accessibility := bucket.acl
} else = accessibility {
	# last cases: acl definition
	not common_lib.valid_key(bucket, "acl")
	accessibility := "private"
}

