package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	[path, Resources] := walk(docs)
	some name in Resources
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"
	prop := resource.Properties
	not common_lib.valid_key(prop, "LoggingConfiguration")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' should have property 'LoggingConfiguration'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' doesn't have property 'LoggingConfiguration'", [name]),
	}
}
