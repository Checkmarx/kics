package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	policy := input.document[i].resource.alicloud_oss_bucket[name].policy
	
    not ip_restricted(policy)

	result := {
		"documentId": input.document[i].id,
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
