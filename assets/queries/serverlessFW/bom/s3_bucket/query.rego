package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	documents := input.document[i]
	provider := documents.provider
	deployment_Bucket := provider.deploymentBucket

	info := get_deploy_resource_accessibility(deployment_Bucket, deployment_Bucket.name)

	bom_output = {
		"resource_type": "AWS S3 Bucket",
		"resource_name": deployment_Bucket.name,
		"resource_accessibility": info.accessibility,
		"resource_encryption": get_deploy_encryption(deployment_Bucket),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_deploy_bucket_acl(deployment_Bucket),
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("provider.deploymentBucket", []),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["provider", "deploymentBucket"], []),
		"value": json.marshal(final_bom_output),
	}
}

CxPolicy[result] {
	documents := input.document[i]
	provider := documents.provider
	s3 := provider.s3[name]

	info := get_resource_accessibility(s3, name)

	bom_output = {
		"resource_type": "AWS S3 Bucket",
		"resource_name": s3.name,
		"resource_accessibility": info.accessibility,
		"resource_encryption": sfw_lib.get_encryption(s3),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(s3),
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("provider.s3.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["provider", "s3", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_bucket_acl(bucket_resource) = acl {
	acl := bucket_resource.accessControl
} else = acl {
	acl := "private"
}

is_public_access_blocked(properties) {
	properties.BlockPublicAcls == true
	properties.BlockPublicPolicy == true
}

get_resource_accessibility(resource, name) = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	is_public_access_blocked(resource.publicAccessBlockConfiguration)
	info := {"accessibility": "private", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acl := get_bucket_acl(resource)
	lower(acl) == "private"
	info := {"accessibility": "private", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility == "hasPolicy"
	info := {"accessibility": "hasPolicy", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acl := get_bucket_acl(resource)
	lower(acl) != "private"
	info := {"accessibility": "public", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility != "hasPolicy"
	info := {"accessibility": acc.accessibility, "policy": acc.policy}
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

get_deploy_encryption(bucket_resource) = encryption {
	common_lib.valid_key(bucket_resource, "serverSideEncryption")
	common_lib.valid_key(bucket_resource, "sseKMSKeyId")
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}

has_default_policy(bucket_resource) {
	bucket_resource.skipPolicySetup == false
} else {
	not common_lib.valid_key(bucket_resource, "skipPolicySetup")
}

get_deploy_resource_accessibility(resource, name) = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility == "private"
	info := {"accessibility": "private", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acl := get_deploy_bucket_acl(resource)
	lower(acl) == "private"
	info := {"accessibility": "private", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility == "hasPolicy"
	info := {"accessibility": "hasPolicy", "policy": acc.policy}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acl := get_deploy_bucket_acl(resource)
	lower(acl) != "private"
	info := {"accessibility": "public", "policy": acc.policy}
} else = info {
	has_default_policy(resource)
	info := {"accessibility": "hasPolicy", "policy": ""}
} else = info {
	acc := sfw_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility != "hasPolicy"
	info := {"accessibility": acc.accessibility, "policy": acc.policy}
}
