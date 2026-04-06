package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties

	envVars := properties.Environment.Variables
	some var
	re_match("(A3T[A-Z0-9]|AKIA|ASIA)[A-Z0-9]{16}", envVars[var])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.Environment.Variables", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Environment.Variables shouldn't contain a hardcoded AWS Access Key", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Environment.Variables contains a hardcoded AWS Access Key", [key]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties", "Environment", "Variables", var], []),
	}
}
