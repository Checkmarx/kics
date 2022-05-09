package Cx

import data.generic.common as common_lib

public_ips  = ["0.0.0.0/0","0.0.0.0"]

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_db_instance[name]
    security_ips := resource.security_ips
    sec_ip := security_ips[x]
    pub_ip := public_ips[_]
    sec_ip == pub_ip


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_db_instance[%s].security_ips.%s", [name,x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not be in 'security_ips' list", [sec_ip]),
		"keyActualValue": sprintf("'%s' is in 'security_ips' list", [sec_ip]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "security_ips", x], []),
	}
}

