package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	acm := task["community.aws.aws_acm"]
	ansLib.checkState(acm)

	acm.certificate.rsa_key_bytes <= 128

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.community.aws.aws_acm.certificate", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'community.aws.aws_acm.certificate' uses a RSA key with length higher than 128 bytes",
		"keyActualValue": "'community.aws.aws_acm.certificate' does not use a RSA key with length higher than 128 bytes",
	}
}
