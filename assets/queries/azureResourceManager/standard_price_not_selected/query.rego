package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Security/pricings"
    not arm_lib.isParameterReference(value.properties.pricingTier)
	lower(value.properties.pricingTier) != "standard"

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.pricingTier", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'pricingTier' should be set to standard",
		"keyActualValue": sprintf("'pricingTier' is set to %s", [value.properties.pricingTier]),
		"searchLine": common_lib.build_search_line(path, ["properties", "pricingTier"]),

	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Security/pricings"
    arm_lib.isParameterReference(value.properties.pricingTier)
	parameterDefValue := arm_lib.getDefaultValueFromParameters(doc, value.properties.pricingTier)
    lower(parameterDefValue) != "standard"

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.pricingTier", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'pricingTier' associated parameter default value should be set to standard",
		"keyActualValue": sprintf("'pricingTier' associated parameter default value is set to %s", [parameterDefValue]),
		"searchLine": common_lib.build_search_line(path, ["properties", "pricingTier"]),
	}
}
