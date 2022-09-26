package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    possibilities:={"public-read", "public-read-write"}
    resource.acl == possibilities[p]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' should be set to private or not set",
		"keyActualValue": sprintf("'acl' is %s", [possibilities[p]]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "acl"], []),
		"remediation": json.marshal({
            "before": p,
            "after": "private"
        }),
        "remediationType": "replacement",
	}
}
