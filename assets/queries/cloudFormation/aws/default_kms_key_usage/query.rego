package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	common_lib.inArray({"AWS::DocDB::DBCluster", "AWS::Neptune::DBCluster", "AWS::RDS::DBCluster", "AWS::RDS::DBInstance", "AWS::Redshift::Cluster"}, resource.Type)

	properties := resource.Properties
	cf_lib.isCloudFormationTrue(properties.StorageEncrypted)
	not common_lib.valid_key(properties, "KmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsKeyId should be defined with AWS-Managed CMK", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsKeyId is undefined", [key]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties"], []),
	}
}
