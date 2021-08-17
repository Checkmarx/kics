package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	acm := task["community.aws.aws_acm"]
	ansLib.checkState(acm)

	expiration_date := acm.certificate.expiration_date
	commonLib.expired(expiration_date)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.community.aws.aws_acm.certificate", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'community.aws.aws_acm.certificate' does not have expired",
		"keyActualValue": "'community.aws.aws_acm.certificate' has expired",
	}
}
