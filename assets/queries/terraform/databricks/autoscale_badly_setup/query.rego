package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	autoscale := resource.autoscale
	not autoscale.min_workers

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].autoscale", [name]),
		"searchValue": "min_workers",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].autoscale.min_workers' should not be empty", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].autoscale.min_workers' is not setup'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "databricks_cluster", name, "autoscale"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	autoscale := resource.autoscale
	not autoscale.max_workers

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].autoscale", [name]),
		"searchValue": "max_workers",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].autoscale.max_workers' should not be empty", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].autoscale.max_workers' is not setup'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "databricks_cluster", name, "autoscale"], []),
	}
}
