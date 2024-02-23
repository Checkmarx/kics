package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	dbInstance := input.document[i].resource.nifcloud_db_instance[name]
    not common_lib.valid_key(dbInstance, "backup_retention_period")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should have backup retention longer than 1 day", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' does not have backup retention period", [name]),
	}
}

CxPolicy[result] {

	dbInstance := input.document[i].resource.nifcloud_db_instance[name]
	dbInstance.backup_retention_period < 2

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should have backup retention longer than 1 day", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' has 1 day backup retention period", [name]),
	}
}
