package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	resource.gcp_attributes.availability == "PREEMPTIBLE_GCP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].gcp_attributes.availability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].gcp_attributes.availability' should not be equal to 'SPOT'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].gcp_attributes.availability' is equal to 'SPOT'", [name]),
	}
}
