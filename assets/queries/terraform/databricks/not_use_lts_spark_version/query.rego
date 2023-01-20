package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].data.databricks_spark_version[name]

	not resource.long_term_support

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_spark_version",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_spark_version[%s].long_term_support", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_spark_version[%s]' should be a LTS version'", [name]),
		"keyActualValue": sprintf("'databricks_spark_version[%s]' is not a LTS version'", [name]),
	}
}
