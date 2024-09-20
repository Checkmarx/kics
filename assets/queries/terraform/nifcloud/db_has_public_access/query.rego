package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	dbInstance := input.document[i].resource.nifcloud_db_instance[name]
    dbInstance.publicly_accessible == true
	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should not use publicly accessible set to true. You should limit all access to the minimum that is required for your application to function.", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' has publicly accessible set to true.", [name]),
	}
}

CxPolicy[result] {

	dbInstance := input.document[i].resource.nifcloud_db_instance[name]
    not common_lib.valid_key(dbInstance, "publicly_accessible")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should have publicly accessible defined as the default value is set to true. You should limit all access to the minimum that is required for your application to function.", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' doesn't define publicly accessible.", [name]),
	}
}