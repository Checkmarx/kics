package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBCluster"
	properties := resource.Properties
	properties.BackupRetentionPeriod < 7

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.BackupRetentionPeriod", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The RDS DBCluster '%s' resource has a minimum backup retention period of at least 7 days", [name]),
		"keyActualValue": sprintf("The RDS DBCluster '%s' resource has backup retention period of '%s' which is less than the minimum of 7 days", [name, properties.BackupRetentionPeriod]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBCluster"
	properties := resource.Properties
	object.get(properties, "BackupRetentionPeriod", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingValue",
		"keyExpectedValue": sprintf("The RDS DBCluster '%s' resource has a minimum backup retention period of at least 7 days", [name]),
		"keyActualValue": sprintf("The RDS DBCluster '%s' resource doesn't define a backup retention period", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	object.get(properties, "BackupRetentionPeriod", "undefined") == "undefined"

	clusterList := [cluster |
		doc.Resources[key].Type == "AWS::RDS::DBCluster"
		cluster := doc.Resources[key]
	]

	count(clusterList) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingValue",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' resource has a minimum backup retention period of at least 7 days", [name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' resource doesn't define a backup retention period and no RDS Cluster are defined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	properties.BackupRetentionPeriod < 7

	clusterList := [cluster |
		doc.Resources[key].Type == "AWS::RDS::DBCluster"
		cluster := doc.Resources[key]
	]

	count(clusterList) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.BackupRetentionPeriod", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' resource has a minimum backup retention period of at least 7 days", [name]),
		"keyActualValue": sprintf("The RDS DBCluster '%s' resource has backup retention period of '%s' which is less than the minimum of 7 days, and no RDS Cluster are defined", [name, properties.BackupRetentionPeriod]),
	}
}
