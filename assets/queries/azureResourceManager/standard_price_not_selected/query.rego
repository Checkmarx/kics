package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Security/pricings"
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.pricingTier)
	lower(val) != "standard"

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.pricingTier", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'pricingTier' should be set to standard",
		"keyActualValue": sprintf("'pricingTier' %s is set to %s", [val_type, val]),
		"searchLine": common_lib.build_search_line(path, ["properties", "pricingTier"]),

	}
}
