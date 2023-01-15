package Cx

import data.generic.terraform as tf_lib

#use spot instance
CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	contains(resource.aws_attributes.availability, "ON_DEMAND")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.availability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.availability' should not equal to 'ON_DEMAND'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.availability' is equal to 'ON_DEMAND'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	resource.aws_attributes.first_on_demand == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.first_on_demand", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' should not equal to '0'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' is equal to '0'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]
	not resource.aws_attributes.first_on_demand

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.first_on_demand", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' should present", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' is not present", [name]),
	}
}
