package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] { #Resource Type DB  and StorageEncrypted is False
	document := input.document[i]
	resource := document.Resources[key]
    common_lib.inArray({"AWS::DocDB::DBCluster", "AWS::Neptune::DBCluster", "AWS::RDS::DBCluster", "AWS::RDS::DBInstance", "AWS::RDS::GlobalCluster"}, resource.Type)

    properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.StorageEncrypted)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.StorageEncrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is false", [key]),
	}
}

CxPolicy[result] { # DBTypes any DB, but without storage encrypted is undefined
	document := input.document[i]
	resource := document.Resources[key]
    common_lib.inArray({"AWS::DocDB::DBCluster", "AWS::Neptune::DBCluster", "AWS::RDS::DBCluster", "AWS::RDS::DBInstance", "AWS::RDS::GlobalCluster"}, resource.Type)

	properties := resource.Properties
	not common_lib.valid_key(properties, "StorageEncrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Redshift::Cluster"

	properties := resource.Properties
	not common_lib.valid_key(properties, "Encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
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
	cf_lib.isCloudFormationFalse(resource.Properties.Encrypted)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Encrypted is false", [key]),
	}
}
