package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	not resource.autoscale

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].autoscale.min_workers' should be setup", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].autoscale' is not setup'", [name]),
	}
}