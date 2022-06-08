package Cx

import data.generic.common as common_lib
<<<<<<< HEAD
=======
import data.generic.terraform as tf_lib
>>>>>>> v1.5.10

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    common_lib.valid_key(resource, "website")

	result := {
<<<<<<< HEAD
    	"debug": sprintf("%s", [resource]),
		"documentId": input.document[i].id,
=======
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
>>>>>>> v1.5.10
		"searchKey": sprintf("alicloud_oss_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'website' to not be used.",
		"keyActualValue": "'website' is being used.",
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "website"], []),
	}
}
