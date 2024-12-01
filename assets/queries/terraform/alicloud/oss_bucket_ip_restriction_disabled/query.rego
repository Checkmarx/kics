package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_oss_bucket[name]
	policy := resource.policy

	not ip_restricted(policy)

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s].policy has restricted ip access", [name]),
		"keyActualValue": sprintf("[%s].policy does not restrict access via ip", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}

ip_restricted(policy) {
	u_policy := common_lib.json_unmarshal(policy)
	statement := common_lib.get_statement(u_policy)
	some st in statement
	possibilities := {"IpAdress", "NotIpAdress"}
	common_lib.valid_key(st.Condition[possibilities[_]], "acs:SourceIp")
}
