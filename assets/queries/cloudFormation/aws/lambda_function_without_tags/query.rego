package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Tags")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Tags' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Tags' is undefined", [name]),
	}
}
