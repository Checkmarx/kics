package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	ansLib.isAnsibleTrue(task["community.aws.redshift"].publicly_accessible)
	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.redshift}}.publicly_accessible", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	ansLib.isAnsibleTrue(task.redshift.publicly_accessible)
	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.redshift.publicly_accessible", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}