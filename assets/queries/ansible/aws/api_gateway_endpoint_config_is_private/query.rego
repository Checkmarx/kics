package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	redshiftCluster := task["community.aws.aws_api_gateway"]

	redshiftCluster.endpoint_type == "PRIVATE"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.aws_api_gateway}}.endpoint_type", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.aws_api_gateway.endpoint_type should be set to EDGE or REGIONAL",
		"keyActualValue": "community.aws.aws_api_gateway.endpoint_type is PRIVATE",
	}
}
