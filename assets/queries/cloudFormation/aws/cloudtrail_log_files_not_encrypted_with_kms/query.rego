package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	kmsKeyID := resource.Properties.KMSKeyId
	kmsKeyID == ""

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KMSKeyId' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KMSKeyId' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	not common_lib.valid_key(resource.Properties, "KMSKeyId")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KMSKeyId' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KMSKeyId' is undefined or null", [name]),
	}
}
