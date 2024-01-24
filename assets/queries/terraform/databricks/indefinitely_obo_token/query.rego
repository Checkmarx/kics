package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_obo_token[name]
	not resource.lifetime_seconds

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_obo_token",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_obo_token[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_obo_token[%s]' should not have indefinitely lifetime", [name]),
		"keyActualValue": sprintf("'databricks_obo_token[%s]' have an indefinitely lifetime", [name]),
	}
}
