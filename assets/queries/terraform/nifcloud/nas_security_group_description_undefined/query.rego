package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	nasSecurityGroup := document.resource.nifcloud_nas_security_group[name]
	not common_lib.valid_key(nasSecurityGroup, "description")

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_nas_security_group",
		"resourceName": tf_lib.get_resource_name(nasSecurityGroup, name),
		"searchKey": sprintf("nifcloud_nas_security_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_nas_security_group[%s]' should include a description for auditing purposes", [name]),
		"keyActualValue": sprintf("'nifcloud_nas_security_group[%s]' does not have a description", [name]),
	}
}
