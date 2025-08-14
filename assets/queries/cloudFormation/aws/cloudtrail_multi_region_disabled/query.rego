package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	common_lib.valid_key(resource.Properties, "IsMultiRegionTrail")

	not cf_lib.isCloudFormationTrue(resource.Properties.IsMultiRegionTrail)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IsMultiRegionTrail", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is not true", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	not common_lib.valid_key(resource.Properties, "IsMultiRegionTrail")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' should exist", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is missing", [name]),
	}
}

