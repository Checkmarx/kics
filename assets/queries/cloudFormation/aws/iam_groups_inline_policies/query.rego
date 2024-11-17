package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::IAM::Group"
	policies := resource.Properties.Policies
	policies != []

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.Policies' should be undefined or empty",
		"keyActualValue": "'Resources.Properties.Policies' is not empty",
	}
}
