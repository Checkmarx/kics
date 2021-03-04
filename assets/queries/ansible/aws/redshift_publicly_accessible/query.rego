package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ansLib.isAnsibleTrue(task["community.aws.redshift"].publicly_accessible)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.redshift}}.publicly_accessible", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ansLib.isAnsibleTrue(task.redshift.publicly_accessible)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.redshift.publicly_accessible", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}
