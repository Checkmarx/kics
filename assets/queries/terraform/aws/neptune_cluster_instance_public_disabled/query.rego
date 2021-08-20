package Cx

CxPolicy[result] {
	neptuneClusterInstance := input.document[i].resource.aws_neptune_cluster_instance[name]

	neptuneClusterInstance.publicy_accessible == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster_instance[%s].publicy_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'publicy_accessible' is 'false'",
		"keyActualValue": "'publicy_accessible' is 'true'",
	}
}
