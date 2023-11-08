package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	resource.azure_attributes.availability == "SPOT_AZURE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].azure_attributes.availability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].azure_attributes.availability' should not be equal to 'SPOT'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].azure_attributes.availability' is equal to 'SPOT'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	resource.azure_attributes.first_on_demand == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].azure_attributes.first_on_demand", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].azure_attributes.first_on_demand' should not be equal to '0'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].azure_attributes.first_on_demand' is equal to '0'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name].azure_attributes
	not resource.first_on_demand

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].azure_attributes.first_on_demand", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].azure_attributes.first_on_demand' should present", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].azure_attributes.first_on_demand' is not present", [name]),
	}
}
