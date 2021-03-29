package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.ca_cert_identifier != "rds-ca-2019"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].ca_cert_identifier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_instance.ca_cert_identifier' is 'rds-ca-2019'",
		"keyActualValue": sprintf("'aws_db_instance.ca_cert_identifier' is '%s'", [resource.ca_cert_identifier]),
	}
}
