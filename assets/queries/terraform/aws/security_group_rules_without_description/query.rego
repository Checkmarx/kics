package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	types := {"ingress", "egress"}
	object.get(resource[types[y]], "description", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[{{%s}}].%s", [name, types[y]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[{{%s}}].%s description is defined", [name, types[y]]),
		"keyActualValue": sprintf("aws_security_group[{{%s}}].%s description is missing", [name, types[y]]),
	}
}
