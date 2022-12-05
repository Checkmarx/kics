package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	s_bucket := input.document[i].resources[idx]
	s_bucket.type == "storage.v1.bucket"

	bom_output = {
		"resource_type": s_bucket.type,
		"resource_name": s_bucket.name,
		"resource_accessibility": get_accessibility(s_bucket),
		"resource_encryption": check_encrytion(s_bucket.properties),
		"resource_vendor": "GCP",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}", [s_bucket.name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", idx], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(properties) = enc_status {
	common_lib.valid_key(properties, "encryption")
	enc_status := "encrypted"
} else = enc_status {
	enc_status := "unencrypted"
}

consideredPublicPolicyMembers := {"allUsers","allAuthenticatedUsers"}

get_accessibility(bucket_res) = accessibility_status{
	access_control := input.document[_].resources[_]
    type := lower(access_control.type) 
	type == "storage.v1.bucketaccesscontrol"
 	ac_properties := access_control.properties
	ac_properties.bucket == bucket_res.name	
	ac_properties.entity == consideredPublicPolicyMembers[_]	
	accessibility_status := "public"
} else = accessibility_status{
	acl_list := bucket_res.properties.acl
	acl_list[_].entity == consideredPublicPolicyMembers[_]	
	accessibility_status := "public"
} else = accessibility_status{
	def_acl_list := bucket_res.properties.defaultObjectAcl
	def_acl_list[_].entity == consideredPublicPolicyMembers[_]	
	accessibility_status := "public"
} else = accessibility_status{
	accessibility_status := "unknown"
}
