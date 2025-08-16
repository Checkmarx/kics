package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_backup_plan[name]

	delete_after_greater_than_cold_storage(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_backup_plan",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_backup_plan[%s].rule.lifecycle.delete_afte", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'delete_after' should be 90 days greater than 'cold_storage_after'",
		"keyActualValue": "'delete_after' should be greater",
	}
}


delete_after_greater_than_cold_storage(resource) {
	# if cold_storage_after is setup
	resource.rule.lifecycle.cold_storage_after > 0
	diff := resource.rule.lifecycle.delete_after - resource.rule.lifecycle.cold_storage_after
	not diff >= 90
}
