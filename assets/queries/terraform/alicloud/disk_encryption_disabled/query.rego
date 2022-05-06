package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_disk[name]
    resource.encrypted == false
  

    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_disk[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s] has encryption set to true", [name]),
		"keyActualValue": sprintf("[%s] has encryption set to false", [name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_disk", name, "encrypted"], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_disk[name]
    not common_lib.valid_key(resource, "encrypted")
	not common_lib.valid_key(resource, "snapshot_id")

    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_disk[%s]",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s] has encryption enabled",[name]),
		"keyActualValue": sprintf("[%s] does not have encryption enabled",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_disk", name], []),
	}
}

