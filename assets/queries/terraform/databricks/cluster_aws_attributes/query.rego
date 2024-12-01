package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.databricks_cluster[name]
	resource.aws_attributes.availability == "SPOT"

	result := {
		"documentId": document.id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.availability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.availability' should not be equal to 'SPOT'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.availability' is equal to 'SPOT'", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.databricks_cluster[name]
	resource.aws_attributes.first_on_demand == 0

	result := {
		"documentId": document.id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.first_on_demand", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' should not be equal to '0'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' is equal to '0'", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.databricks_cluster[name].aws_attributes
	not resource.first_on_demand

	result := {
		"documentId": document.id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.first_on_demand", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' should present", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.first_on_demand' is not present", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.databricks_cluster[name].aws_attributes
	not resource.zone_id == "auto"

	result := {
		"documentId": document.id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].aws_attributes.zone_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].aws_attributes.zone_id' should be egal to 'auto'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].aws_attributes.zone_id' is not equal to 'auto'", [name]),
	}
}
