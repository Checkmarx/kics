package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name].ingress
	some j
	resource.cidr_blocks[j] == "0.0.0.0/0"
	portNumber := 3389
	resource.from_port <= portNumber
	resource.to_port >= portNumber

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress doesn't open the remote desktop port (%s)", [name, portNumber]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress opens the remote desktop port (%s)", [name, portNumber]),
	}
}
