package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	dbInstance := document.resource.nifcloud_db_instance[name]
	not common_lib.valid_key(dbInstance, "backup_retention_period")

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should have backup retention of at least 7 days", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' doesn't have a backup retention period defined", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	dbInstance := document.resource.nifcloud_db_instance[name]
	dbInstance.backup_retention_period < 7

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should have backup retention of at least 7 days", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' has backup retention period of '%s' which is less than minimum of 7 days", [name, dbInstance.backup_retention_period]),
	}
}
