package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	bucket_resource := input.document[i].resource.aws_s3_bucket[name]

	info := get_accessibility(bucket_resource, name)

	bom_output = {
		"resource_type": "aws_s3_bucket",
		"resource_name": get_bucket_name(bucket_resource),
		"resource_accessibility": info.accessibility,
		"resource_encryption": common_lib.get_encryption_if_exists(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(bucket_resource),
	}

	final_bom_output = common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_bucket_acl(bucket_resource) = acl {
	acl := bucket_resource.acl
} else = acl {
	acl := "private"
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

get_accessibility(bucket, bucketName) = accessibility {
	# cases when public access is blocked by aws_s3_bucket_public_access_block
	s3BucketPublicAccessBlock := input.document[i].resource.aws_s3_bucket_public_access_block[_]
	split(s3BucketPublicAccessBlock.bucket, ".")[1] == bucketName
	is_public_access_blocked(s3BucketPublicAccessBlock)
	accessibility = {"accessibility": "private", "policy": ""}
} else = accessibility {
	# cases when there is a unrestriced policy
	acc := terra_lib.get_accessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")
    acc.accessibility == "hasPolicy"   
    
    accessibility = {"accessibility": "hasPolicy", "policy": acc.policy}   
} else = accessibility {
	# last cases: acl definition
	accessibility = {"accessibility": bucket.acl, "policy": ""}
} else = accessibility {
	# last cases: acl definition
	not common_lib.valid_key(bucket, "acl")
	accessibility = {"accessibility": "private", "policy": ""}
}

