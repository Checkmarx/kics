package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	neptuneClusterInstance := input.document[i].resource.aws_neptune_cluster_instance[name]

	neptuneClusterInstance.publicly_accessible == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_neptune_cluster_instance",
		"resourceName": tf_lib.get_resource_name(neptuneClusterInstance, name),
		"searchKey": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_neptune_cluster_instance", name, "publicly_accessible"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible should be set to false", [name]),
		"keyActualValue": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible is set to true", [name]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
