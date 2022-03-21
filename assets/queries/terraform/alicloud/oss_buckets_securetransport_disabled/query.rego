package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	policy := input.document[i].resource.alicloud_oss_bucket[name].policy
	
	not is_secure_transport(policy)
	

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy does not accept HTTP Requests",[name]),
		"keyActualValue": sprintf("%s[%s].policy accepts HTTP Requests",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}

is_equal(secure, target)
{
    secure == target
}else {
    secure[_]==target
}

is_secure_transport(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	statement := st[_]
	statement.Effect == "Deny"   
	is_equal(statement.Condition.Bool["acs:SecureTransport"], "false")
    terra_lib.anyPrincipal(statement)
}else {
    policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	statement := st[_]
	statement.Effect == "Allow"
	is_equal(statement.Condition.Bool["acs:SecureTransport"], "true")
    terra_lib.anyPrincipal(statement)
}



