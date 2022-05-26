package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	prop := resource.Properties
	not common_lib.valid_key(prop, "LoggingConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' has property 'LoggingConfiguration'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' doesn't have property 'LoggingConfiguration'", [name]),
	}
}
