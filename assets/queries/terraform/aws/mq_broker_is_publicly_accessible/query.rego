package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	broker := document.resource.aws_mq_broker[name]
	broker.publicly_accessible == true

	result := {
		"documentId": document.id,
		"resourceType": "aws_mq_broker",
		"resourceName": tf_lib.get_specific_resource_name(broker, "aws_mq_broker", name),
		"searchKey": sprintf("aws_mq_broker[%s].publicly_accessible", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_mq_broker", name, "publicly_accessible"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'publicly_accessible' should be undefined or set to false",
		"keyActualValue": "'publicly_accessible' is set to true",
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
