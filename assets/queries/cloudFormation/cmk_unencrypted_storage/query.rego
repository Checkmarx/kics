package Cx

import data.generic.cloudformation as cldLib
import data.generic.common as commonLib

CxPolicy[result] { #Resource Type DB  and StorageEncrypted is False
	document := input.document[i]
	resource := document.Resources[key]
    commonLib.inArray({"AWS::DocDB::DBCluster", "AWS::Neptune::DBCluster", "AWS::RDS::DBCluster", "AWS::RDS::DBInstance", "AWS::RDS::GlobalCluster"}, resource.Type)

    properties := resource.Properties
	cldLib.isCloudFormationFalse(properties.StorageEncrypted)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StorageEncrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is false", [key]),
	}
}

CxPolicy[result] { # DBTypes any DB, but without storage encrypted is undefined
	document := input.document[i]
	resource := document.Resources[key]
    commonLib.inArray({"AWS::DocDB::DBCluster", "AWS::Neptune::DBCluster", "AWS::RDS::DBCluster", "AWS::RDS::DBInstance", "AWS::RDS::GlobalCluster"}, resource.Type)

	properties := resource.Properties
	object.get(properties, "StorageEncrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	commonLib.inArray({"AWS::DocDB::DBCluster", "AWS::Neptune::DBCluster", "AWS::RDS::DBCluster", "AWS::RDS::DBInstance", "AWS::Redshift::Cluster"}, resource.Type)

	properties := resource.Properties
	object.get(properties, "KmsKeyId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsKeyId should be defined with AWS-Managed CMK", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsKeyId is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Redshift::Cluster"

	properties := resource.Properties
	object.get(properties, "Encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Redshift::Cluster"
	cldLib.isCloudFormationFalse(resource.Properties.Encrypted)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is false", [key]),
	}
}
