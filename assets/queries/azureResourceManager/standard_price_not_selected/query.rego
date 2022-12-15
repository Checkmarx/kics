package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Security/pricings"
    not isParameterReference(value.properties.pricingTier)
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
    isParameterReference(value.properties.pricingTier)
	parameterDefValue := getDefaultValueFromParameters(doc, value.properties.pricingTier)
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

getDefaultValueFromParameters(doc, valueToCheck) = value {
	parameterName := isParameterReference(valueToCheck)
	parameter := doc.parameters[parameterName].defaultValue
	value := parameter
}

isParameterReference(valueToCheck) = parameterName {
	startswith(valueToCheck, "[parameters('")
	endswith(valueToCheck, "')]")
	parameterName := trim_right(trim_left(valueToCheck, "[parameters('"),"')]")
}
