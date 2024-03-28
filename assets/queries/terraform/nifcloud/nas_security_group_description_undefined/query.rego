package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	nasSecurityGroup := input.document[i].resource.nifcloud_nas_security_group[name]
	not common_lib.valid_key(nasSecurityGroup, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_nas_security_group",
		"resourceName": tf_lib.get_resource_name(nasSecurityGroup, name),
		"searchKey": sprintf("nifcloud_nas_security_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_nas_security_group[%s]' should include a description for auditing purposes", [name]),
		"keyActualValue": sprintf("'nifcloud_nas_security_group[%s]' does not have a description", [name]),
	}
}
