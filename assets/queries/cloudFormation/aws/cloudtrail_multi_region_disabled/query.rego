package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	common_lib.valid_key(resource.Properties, "IsMultiRegionTrail")
	not checkRegion(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IsMultiRegionTrail", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is false", [name]),
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
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' exists", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is missing", [name]),
	}
}

checkRegion(cltr) {
	cltr.Properties.IsMultiRegionTrail == true
}
