package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Security/pricings"
	lower(value.properties.pricingTier) != "standard"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties.pricingTier", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'pricingTier' is set to standard",
		"keyActualValue": sprintf("'pricingTier' is set to %s", [value.properties.pricingTier]),
	}
}
