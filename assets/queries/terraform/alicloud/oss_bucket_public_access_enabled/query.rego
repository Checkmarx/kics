package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    possibilities:={"public-read", "public-read-write"}
    resource.acl == possibilities[p]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' is set to private or not set",
		"keyActualValue": sprintf("'acl' is %s", [possibilities[p]]),
        "searchline":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "acl"], []),
	}
}
