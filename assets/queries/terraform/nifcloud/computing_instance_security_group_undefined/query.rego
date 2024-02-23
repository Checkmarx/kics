package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	instance := input.document[i].resource.nifcloud_instance[name]
    not common_lib.valid_key(instance, "security_group")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_instance",
		"resourceName": tf_lib.get_resource_name(instance, name),
		"searchKey": sprintf("nifcloud_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_instance[%s]' should include a security_group for security purposes", [name]),
		"keyActualValue": sprintf("'nifcloud_instance[%s]' does not have a security_group", [name]),
	}
}
