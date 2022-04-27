package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    common_lib.valid_key(resource, "website")

	result := {
    	"debug": sprintf("%s", [resource]),
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'website' to not be used.",
		"keyActualValue": "'website' is being used.",
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "website"], []),
	}
}
