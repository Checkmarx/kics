package Cx

CxPolicy[result] {
	neptuneClusterInstance := input.document[i].resource.aws_neptune_cluster_instance[name]

	neptuneClusterInstance.publicly_accessible == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible is set to false", [name]),
		"keyActualValue": sprintf("aws_neptune_cluster_instance[%s].publicly_accessible is set to true", [name]),
	}
}
