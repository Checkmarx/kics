package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"

	common_lib.valid_key(resource.Properties, "WebsiteConfiguration") # ensure that is defined and not null
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path),name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.WebsiteConfiguration' should not be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.WebsiteConfiguration' is defined", [name]),
		"searchLine": common_lib.build_search_line(path,[name, "Properties", "WebsiteConfiguration"]),
	}
}
