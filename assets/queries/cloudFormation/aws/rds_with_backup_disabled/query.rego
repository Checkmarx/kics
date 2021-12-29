package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
    to_number(resource.Properties.BackupRetentionPeriod) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.BackupRetentionPeriod", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.BackupRetentionPeriod' is not equal to zero", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.BackupRetentionPeriod' is equal to zero", [name]),
	}
}
