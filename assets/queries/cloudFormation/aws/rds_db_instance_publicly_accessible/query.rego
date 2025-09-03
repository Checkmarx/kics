package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.PubliclyAccessible", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' should be set to false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is set to true", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "PubliclyAccessible"]),
	}
}
