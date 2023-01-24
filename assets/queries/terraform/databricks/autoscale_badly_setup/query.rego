package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	not resource.autoscale.min_workers

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].autoscale", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].autoscale.min_workers' should not be empty", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].autoscale.min_workers' is not setup'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	not resource.autoscale.max_workers

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].autoscale", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].autoscale.max_workers' should not be empty", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].autoscale.max_workers' is not setup'", [name]),
	}
}
