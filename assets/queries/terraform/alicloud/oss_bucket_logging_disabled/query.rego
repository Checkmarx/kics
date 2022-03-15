package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_oss_bucket[name]
    not common_lib.valid_key(resource,"logging")
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s has logging enabled",[name]),
		"keyActualValue": sprintf("%s does not have logging enabled",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}
