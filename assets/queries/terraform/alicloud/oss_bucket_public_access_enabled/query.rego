package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    possibilities:={"public-read", "public-read-write"}
    resource.acl == possibilities[_]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' is set to private or not set",
		"keyActualValue": "'acl' is public-read or public read-write",
        "searchline":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "acl"], []),
	}
}
