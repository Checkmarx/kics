package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_oss_bucket[name]
	policy := resource.policy
	
    not ip_restricted(policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s].policy has restricted ip access",[name]),
		"keyActualValue": sprintf("[%s].policy does not restrict access via ip",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}

ip_restricted(policy)
{
	u_policy := common_lib.json_unmarshal(policy)
	statement := common_lib.get_statement(u_policy)
    st:=statement[_]
    possibilities := {"IpAdress", "NotIpAdress"}
    common_lib.valid_key(st.Condition[possibilities[_]], "acs:SourceIp")
}
