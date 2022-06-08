package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	restrictionType := input.document[i].Resources[name].Properties[j].Restrictions.GeoRestriction.RestrictionType
	check_action(restrictionType)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Restrictions.GeoRestriction.RestrictionType", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Restrictions.GeoRestriction.RestrictionType should be enabled with whitelist or blacklist", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Restrictions.GeoRestriction.RestrictionTypeallows is configured with none. Therefore, Geo Restriction is not enabled and it should be", [name]),
	}
}

check_action(action) {
	is_string(action)
	not contains(lower(action), "whitelist")
	not contains(lower(action), "blacklist")
}
