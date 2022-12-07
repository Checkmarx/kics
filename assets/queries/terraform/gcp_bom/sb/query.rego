package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	s_bucket := input.document[i].resource.google_storage_bucket[name]

	bom_output = {
		"resource_type": "google_storage_bucket",
		"resource_name": tf_lib.get_resource_name(s_bucket, name),
		"resource_accessibility": get_accessibility(name),
		"resource_encryption": check_encrytion(s_bucket),
		"resource_vendor": "GCP",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "google_storage_bucket", name], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(resource) = enc_status {
	common_lib.valid_key(resource, "encryption")
	enc_status := "encrypted"
} else = enc_status {
	enc_status := "unencrypted"
}

consideredPublicPolicyMembers := {"allUsers","allAuthenticatedUsers"}

get_accessibility(bucket_name) = accessibility_status{
 	access_control :=	input.document[i].resource.google_storage_bucket_access_control[_]
	bucketRefArray := split(access_control.bucket, ".")
	bucketRefArray[1] == bucket_name
	access_control.entity == consideredPublicPolicyMembers[_]	
	accessibility_status :="public"
} else = accessibility_status{
 	iam_binding :=	input.document[i].resource.google_storage_bucket_iam_binding[_]
	bucketRefArray := split(iam_binding.bucket, ".")
	bucketRefArray[1] == bucket_name
	checkMembers(iam_binding)	
	accessibility_status :="public"
} else = accessibility_status {
	iam_member :=	input.document[i].resource.google_storage_bucket_iam_member[_]
	bucketRefArray := split(iam_member.bucket, ".")
	bucketRefArray[1] == bucket_name
	checkMembers(iam_member)
	accessibility_status := "public"
} else = accessibility_status{
	accessibility_status := "unknown"
}

checkMembers(resource) {
	common_lib.valid_key(resource, "members")
	equalsOrInArray(resource.members, consideredPublicPolicyMembers[_])
} else {
	common_lib.valid_key(resource, "member")
	equalsOrInArray(resource.member, consideredPublicPolicyMembers[_])
}

equalsOrInArray(field, value) {
	is_string(field)
	field == value
}

equalsOrInArray(field, value) {
	is_array(field)
	field[i] == value
}
