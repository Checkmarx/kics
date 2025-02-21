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

CxPolicy[result] {
	resource := input.document[i].resource.databricks_cluster[name]

	not isLtsVersion(resource.spark_version)
	not contains(resource.spark_version, "data.databricks_spark_version")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_spark_version",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_cluster[%s].spark_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_cluster[%s].spark_version' should be a LTS version'", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s].spark_version' is not a LTS version'", [name]),
	}
}

isLtsVersion(version) {
	versions = {"3.1.2", "3.2.1", "3.3.0", "3.3.2", "3.4.1", "3.5.0"}
	version = versions[j]
}
