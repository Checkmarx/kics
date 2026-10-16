package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

rdsResources := {"aws_db_instance", "aws_rds_cluster"}

CxPolicy[result] {
	resourceType := rdsResources[_]
	resource := input.document[i].resource[resourceType][name]

	not common_lib.valid_key(resource, "deletion_protection")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [resourceType, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].deletion_protection' should be defined and set to true", [resourceType, name]),
		"keyActualValue": sprintf("'%s[%s].deletion_protection' is undefined or null", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name], []),
		"remediation": "deletion_protection = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resourceType := rdsResources[_]
	resource := input.document[i].resource[resourceType][name]

	resource.deletion_protection == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].deletion_protection", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].deletion_protection' should be set to true", [resourceType, name]),
		"keyActualValue": sprintf("'%s[%s].deletion_protection' is set to false", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "deletion_protection"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
