package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[k]
	resource.Type == "AWS::Serverless::Function"

	resources[j].Type == "AWS::Serverless::Function"
	resources[j].Properties.Role == resource.Properties.Role
	k != j

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, k),
		"searchKey": sprintf("Resources.%s.Properties.Role", [k]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource.%s.Properties.Role is only assigned to the function in question", [k]),
		"keyActualValue": sprintf("Resource.%s.Properties.Role is assigned to another funtion", [k]),
	    "searchLine": common_lib.build_search_line(["Resources", k, "Properties", "Role"], []),
	}
}
