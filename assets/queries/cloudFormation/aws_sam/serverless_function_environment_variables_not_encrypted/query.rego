package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Function"
	properties := resource.Properties

	properties.Environment.Variables
	not common_lib.valid_key(properties, "KmsKeyArn")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyArn' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyArn' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
