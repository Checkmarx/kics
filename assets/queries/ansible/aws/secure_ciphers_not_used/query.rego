package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudfront_distribution"].publicly_accessible)
	isAnsibleFalse(task["community.aws.cloudfront_distribution"].viewer_certificate.cloudfront_default_certificate)
	not checkMinPortocolVersion(task["community.aws.cloudfront_distribution"].viewer_certificate.minimum_protocol_version)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.viewer_certificate.minimum_protocol_version", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.viewer_certificate.minimum_protocol_version is TLSv1.1 or TLSv1.2", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.viewer_certificate.minimum_protocol_version isn't TLSv1.1 or TLSv1.2", [task.name]),
	}
}

isAnsibleFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}

checkMinPortocolVersion(version) {
	version == "TLSv1.1"
}

checkMinPortocolVersion(version) {
	version == "TLSv1.2"
}
