package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.databricks_obo_token[name]
	not resource.lifetime_seconds

	result := {
		"documentId": document.id,
		"resourceType": "databricks_obo_token",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_obo_token[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_obo_token[%s]' should not have indefinitely lifetime", [name]),
		"keyActualValue": sprintf("'databricks_obo_token[%s]' have an indefinitely lifetime", [name]),
	}
}
