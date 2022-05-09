package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_disk[name]
    not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s] has kms key id defined", [name]),
		"keyActualValue": sprintf("[%s] does not have kms key id defined", [name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_disk", name], []),
	}
}
