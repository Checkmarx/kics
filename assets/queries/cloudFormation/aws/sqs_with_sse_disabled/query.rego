package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::SQS::Queue"

	not common_lib.valid_key(resource.Properties, "KmsMasterKeyId")
	SqsManagedSseNotEnabled(resource.Properties)
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsMasterKeyId should be set or SqsManagedSseEnabled set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsMasterKeyId is undefined and SqsManagedSseEnabled not enabled", [name]),
	}
}

SqsManagedSseNotEnabled(Properties) {
	not common_lib.valid_key(Properties, "SqsManagedSseEnabled")
} else {
	cf_lib.isCloudFormationFalse(Properties.SqsManagedSseEnabled)
}
