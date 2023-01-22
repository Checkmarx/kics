package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	databricks_job := input.document[i].resource.databricks_job[name]

	is_associated_to_job(name, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_job",
		"resourceName": tf_lib.get_specific_resource_name(databricks_job, "databricks_job", name),
		"searchKey": sprintf("databricks_job[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_job[%s]' should have permissions", [name]),
		"keyActualValue": sprintf("'databricks_job[%s]' doesn't have permission associated", [name]),
	}
}

is_associated_to_job(databricks_job_name, doc) {
	[path, value] := walk(doc)
	databricks_permissions_used := value.databricks_permissions[_]
	not contains(databricks_permissions_used.job_id, sprintf("databricks_job.%s", [databricks_job_name]))
}


CxPolicy[result] {
	databricks_cluster := input.document[i].resource.databricks_cluster[name]

	is_associated_to_cluster(name, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_cluster",
		"resourceName": tf_lib.get_specific_resource_name(databricks_cluster, "databricks_cluster", name),
		"searchKey": sprintf("databricks_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'databricks_cluster[%s]' should have permissions", [name]),
		"keyActualValue": sprintf("'databricks_cluster[%s]' doesn't have permission associated", [name]),
	}
}

is_associated_to_cluster(databricks_cluster_name, doc) {
	[path, value] := walk(doc)
	databricks_permissions_used := value.databricks_permissions[_]
	not contains(databricks_permissions_used.cluster_id, sprintf("databricks_cluster.%s", [databricks_cluster_name]))
}

CxPolicy[result] {
	databricks_permissions := input.document[i].resource.databricks_permissions[name]

	databricks_permissions.access_control.permission_level == "IS_OWNER"; not databricks_permissions.access_control.service_principal_name

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_permissions",
		"resourceName": tf_lib.get_specific_resource_name(databricks_permissions, "databricks_permissions", name),
		"searchKey": sprintf("databricks_permissions.[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_permissions[%s]' should not have permission_level == 'IS_OWNER' without service_principal_name associated", [name]),
		"keyActualValue": sprintf("'databricks_permissions[%s]' have permission_level == 'IS_OWNER' without service_principal_name associated", [name]),
	}
}

CxPolicy[result] {
	databricks_permissions := input.document[i].resource.databricks_permissions[name]

	some j
	databricks_permissions.access_control[j].permission_level == "IS_OWNER"; not databricks_permissions.access_control[j].service_principal_name

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_permissions",
		"resourceName": tf_lib.get_specific_resource_name(databricks_permissions, "databricks_permissions", name),
		"searchKey": sprintf("databricks_permissions.[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_permissions[%s]' should not have permission_level == 'IS_OWNER' without service_principal_name associated", [name]),
		"keyActualValue": sprintf("'databricks_permissions[%s]' have permission_level == 'IS_OWNER' without service_principal_name associated", [name]),
	}
}
