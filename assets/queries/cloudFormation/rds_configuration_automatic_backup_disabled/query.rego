package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
    backupRetentionPeriod = to_number(resource.Properties.BackupRetentionPeriod)
	backupRetentionPeriod == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.BackupRetentionPeriod", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.Properties.BackupRetentionPeriod' has backup enabled", [name]),
		"keyActualValue": sprintf("'Resources.Properties.BackupRetentionPeriod' doesn't have backup enabled", [name]),
	}
}