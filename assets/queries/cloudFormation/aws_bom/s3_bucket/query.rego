package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	bucket_resource := document[i].Resources[name]
	bucket_resource.Type == "AWS::S3::Bucket"

	info := get_resource_accessibility(bucket_resource, name)

	bom_output = {
		"resource_type": "AWS::S3::Bucket",
		"resource_name": cf_lib.get_resource_name(bucket_resource, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(bucket_resource),
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

get_bucket_acl(bucket_resource) = acl {
	acl := bucket_resource.Properties.AccessControl
} else = acl {
	acl := "Private"
}

is_public_access_blocked(properties) {
	properties.BlockPublicAcls == true
	properties.BlockPublicPolicy == true
}

get_resource_accessibility(resource, name) = info {
	is_public_access_blocked(resource.Properties.PublicAccessBlockConfiguration)
	info := {"accessibility": "Private", "policy": ""}
} else = info {
	acc := cf_lib.get_resource_accessibility(name, "AWS::S3::BucketPolicy", "Bucket")
	acc.accessibility == "hasPolicy"
	info := {"accessibility": "hasPolicy", "policy": acc.policy}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
}
