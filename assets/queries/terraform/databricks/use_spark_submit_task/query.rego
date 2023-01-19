package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_job[name]

	resource.task.spark_submit_task

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_job[%s].task.spark_submit_task", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_job[%s].task.spark_submit_task' should not contains to 'spark_submit_task'", [name]),
		"keyActualValue": sprintf("'databricks_job[%s].task.spark_submit_task' contains to 'spark_submit_task'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_job[name]

	some j
	resource.task[j].spark_submit_task

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_job[%s].task.spark_submit_task", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_job[%s].task.spark_submit_task' should not contains to 'spark_submit_task'", [name]),
		"keyActualValue": sprintf("'databricks_job[%s].task.spark_submit_task' contains to 'spark_submit_task'", [name]),
	}
}
