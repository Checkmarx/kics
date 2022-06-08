package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	neptuneClusterInstance := input.document[i].resource.aws_neptune_cluster_instance[name]

	neptuneClusterInstance.publicly_accessible == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_neptune_cluster_instance",
		"resourceName": tf_lib.get_resource_name(neptuneClusterInstance, name),
		"searchKey": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible is set to false", [name]),
		"keyActualValue": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible is set to true", [name]),
	}
}
