
package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not key_set_to_false(resource)
    not common_lib.valid_key(resource, "enable_key_rotation")
    customer_master_key_spec_set_to_symmetric(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].enable_key_rotation is undefined", [name]),
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not key_set_to_false(resource)
    resource.enable_key_rotation == true
    common_lib.valid_key(resource, "customer_master_key_spec")
    not customer_master_key_spec_set_to_symmetric(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to false", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].enable_key_rotation is true", [name]),
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not key_set_to_false(resource)
    resource.enable_key_rotation == false
    customer_master_key_spec_set_to_symmetric(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].enable_key_rotation is false", [name]),
	}
}



CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not key_set_to_false(resource)
    resource.enable_key_rotation == false
    not common_lib.valid_key(resource, "customer_master_key_spec")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to false", [name]),
	}
}



customer_master_key_spec_set_to_symmetric(resource) {
     resource.customer_master_key_spec == "SYMMETRIC_DEFAULT"
}

key_set_to_false(resource) {
	resource.is_enabled == false
}
