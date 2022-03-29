package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	bucket_resource := document[i].Resources[name]
	bucket_resource.Type == "AWS::S3::Bucket"

	bom_output = {
		"resource_type": "AWS::S3::Bucket",
		"resource_name": get_bucket_name(bucket_resource),
		"resource_accessibility": "TO DO",
		"resource_encryption": get_encryption(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(bucket_resource),
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

get_bucket_acl(bucket_resource) = acl {
	acl := bucket_resource.Properties.AccessControl
} else = acl {
	acl := "private"
}

get_bucket_name(bucket_resource) = name {
	name := bucket_resource.Properties.BucketName
} else = name {
	name := "unknown"
}

get_encryption(bucket_resource) = encryption {
	common_lib.valid_key(bucket_resource.Properties, "BucketEncryption")
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
