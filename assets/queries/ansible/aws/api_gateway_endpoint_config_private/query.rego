package Cx

import data.generic.ansible as ansLib
CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.aws_api_gateway"].publicly_accessible)
	redshiftCluster := task["community.aws.aws_api_gateway"]
	redshiftCluster.endpoint_type == "PRIVATE"
	clusterName := task.name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_api_gateway}}.endpoint_type", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.aws_api_gateway.endpoint_type should be set to EDGE or REGIONAL",
		"keyActualValue": "community.aws.aws_api_gateway.endpoint_type is PRIVATE",
	}
}

