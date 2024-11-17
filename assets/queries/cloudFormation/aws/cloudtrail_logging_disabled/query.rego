package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {~
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	resource.Properties.IsLogging == false

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IsLogging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsLogging' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsLogging' is false", [name]),
	}
}
