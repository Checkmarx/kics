package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"
	common_lib.valid_key(resource, "Properties")
	not common_lib.valid_key(resource.Properties, "VersioningConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VersioningConfiguration should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.VersioningConfiguration is undefined", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"
	resource.Properties.VersioningConfiguration.Status == "Suspended"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.VersioningConfiguration.Status", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VersioningConfiguration.Status should be set to Enabled", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.VersioningConfiguration.Status is set to Suspended", [name]),
	}
}
