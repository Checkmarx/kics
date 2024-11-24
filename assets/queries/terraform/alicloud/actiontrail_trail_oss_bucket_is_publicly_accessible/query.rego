package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	actiontrail := document.resource.alicloud_actiontrail_trail[name]
	bucket_name := actiontrail.oss_bucket_name
	bucket := input.document[_].resource.alicloud_oss_bucket[_]
	possibilities := {"public-read", "public-read-write"}
	bucket.bucket == bucket_name
	bucket.acl == possibilities[p]

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(actiontrail, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'alicloud_oss_bucket[%s].oss_bucket_name' is private", [name]),
		"keyActualValue": sprintf("'alicloud_oss_bucket[%s].oss_bucket_name' is %s", [name, possibilities[p]]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "acl"], []),
		"remediation": json.marshal({
			"before": p,
			"after": "private",
		}),
		"remediationType": "replacement",
	}
}
