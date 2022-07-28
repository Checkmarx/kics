package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	bucket_resource := input.document[i].resource.aws_s3_bucket[name]

	info := get_accessibility(bucket_resource, name)

	bom_output = {
		"resource_type": "aws_s3_bucket",
		"resource_name": tf_lib.get_specific_resource_name(bucket_resource, "aws_s3_bucket", name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": get_encryption_if_exists(bucket_resource, name),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(bucket_resource, name),
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

get_bucket_acl(bucket_resource, s3BucketName) = acl {
	# version before TF AWS 4.0
	acl := bucket_resource.acl
} else = acl { 
	# version after TF AWS 4.0
	bucketAcl := input.document[_].resource.aws_s3_bucket_acl[_]
	split(bucketAcl.bucket, ".")[1] == s3BucketName
	acl := bucketAcl.acl
} else = acl { 
	# version after TF AWS 4.0
	bucketAcl := input.document[_].resource.aws_s3_bucket_acl[_]
	split(bucketAcl.bucket, ".")[1] == s3BucketName
	not common_lib.valid_key(bucketAcl, "acl")
	not common_lib.valid_key(bucketAcl, "access_control_policy")
	acl := "unknown"
} else = acl { 
	# version after TF AWS 4.0
	bucketAcl := input.document[_].resource.aws_s3_bucket_acl[_]
	split(bucketAcl.bucket, ".")[1] == s3BucketName
	not common_lib.valid_key(bucketAcl, "acl")
	common_lib.valid_key(bucketAcl, "access_control_policy")
	acl := "unknown"
} else = acl {
	# version before TF AWS 4.0
	not tf_lib.has_target_resource(s3BucketName, "aws_s3_bucket_acl")
	acl := "private"
}

is_public_access_blocked(s3BucketPublicAccessBlock) {
	s3BucketPublicAccessBlock.block_public_acls == true
    s3BucketPublicAccessBlock.block_public_policy == true
}

get_accessibility(bucket, bucketName) = accessibility {
	# cases when public access is blocked by aws_s3_bucket_public_access_block
	s3BucketPublicAccessBlock := input.document[i].resource.aws_s3_bucket_public_access_block[_]
	split(s3BucketPublicAccessBlock.bucket, ".")[1] == bucketName
	acc := tf_lib.get_accessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")
	is_public_access_blocked(s3BucketPublicAccessBlock)
	accessibility = {"accessibility": "private", "policy": acc.policy}
} else = accessibility {
	# cases when there is a unrestriced policy
	acc := tf_lib.get_accessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")  
    # last cases: acl definition
	acl:= get_bucket_acl(bucket, bucketName)
	acl == "private"
    accessibility = {"accessibility": "private", "policy": acc.policy}   
} else = accessibility {
	# cases when there is a unrestriced policy
	acc := tf_lib.get_accessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")  
    acc.accessibility == "hasPolicy"
    accessibility = {"accessibility": acc.accessibility, "policy": acc.policy}   
} else = accessibility {
	# cases when there is a unrestriced policy
	acc := tf_lib.get_accessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")  
    # last cases: acl definition
	acl:= get_bucket_acl(bucket, bucketName)
	acl != "private"
    accessibility = {"accessibility": "public", "policy": acc.policy}   
} else = accessibility {
	# cases when there is a unrestriced policy
	acc := tf_lib.get_accessibility(bucket, bucketName, "aws_s3_bucket_policy", "bucket")  
    acc.accessibility != "hasPolicy"
    accessibility = {"accessibility": acc.accessibility, "policy": acc.policy}   
}

get_encryption_if_exists(bucket_resource, s3BucketName) = encryption {
	# version before TF AWS 4.0
	common_lib.valid_key(bucket_resource, "server_side_encryption_configuration")
	encryption := "encrypted"
} else = encryption {
	# version after TF AWS 4.0
	bucketAcl := input.document[_].resource.aws_s3_bucket_acl[_]
	split(bucketAcl.bucket, ".")[1] == s3BucketName
	tf_lib.has_target_resource(s3BucketName, "aws_s3_bucket_server_side_encryption_configuration")
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
