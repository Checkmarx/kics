package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	documents := input.document[i]
	provider := documents.provider
	deployment_Bucket := provider.deploymentBucket

	info := get_resource_accessibility(deployment_Bucket, name)

	bom_output = {
		"resource_type": "AWS::S3::Bucket",
		"resource_name": cf_lib.get_resource_name(bucket_resource, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": get_encryption(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_deploy_bucket_acl(deployment_Bucket),
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_deploy_bucket_acl(bucket_resource) = acl {
	bucket_resource.blockPublicAccess == true  
	acl := "private"
} else = acl {
	bucket_resource.blockPublicAccess == false  
	acl := "public"
} else = acl {
	acl := "public"
}

get_encryption(bucket_resource) = encryption {
	common_lib.valid_key(bucket_resource, "serverSideEncryption")
	common_lib.valid_key(bucket_resource, "sseKMSKeyId")
    encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}

is_public_access_blocked(properties) {
	properties.BlockPublicAcls == true
	properties.BlockPublicPolicy == true
}

get_resource_accessibility(resource, name) = info {
	acc := cf_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	is_public_access_blocked(resource.Properties.PublicAccessBlockConfiguration)
	info := {"accessibility": "private", "policy": acc.policy}
} else = info {
	acc := cf_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acl := get_bucket_acl(resource)
	lower(acl) == "private"
	info := {"accessibility": "private", "policy": acc.policy}
} else = info {
	acc := cf_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility == "hasPolicy"
	info := {"accessibility": "hasPolicy", "policy": acc.policy}
} else = info {
	acc := cf_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acl := get_bucket_acl(resource)
	lower(acl) != "private"
	info := {"accessibility": "public", "policy": acc.policy}
} else = info {
	acc := cf_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility != "hasPolicy"
	info := {"accessibility": acc.accessibility, "policy": acc.policy}
}
