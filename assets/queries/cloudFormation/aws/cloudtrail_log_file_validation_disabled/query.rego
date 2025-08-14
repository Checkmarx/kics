package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	not common_lib.valid_key(resource.Properties, "EnableLogFileValidation")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' should exist", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' is missing", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	cf_lib.isCloudFormationFalse(resource.Properties.EnableLogFileValidation)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.EnableLogFileValidation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' is not true", [name]),
	}
}
