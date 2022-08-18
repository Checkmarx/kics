package Cx

import data.generic.common as common_lib

# Check outside parent resource
CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites/config"
	endswith(value.name, "authsettings")
	not value.properties.enabled

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "resource authsettings should have 'properties.enabled' property set to true",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

# Check inside parent resource
CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	common_lib.valid_key(value, "resources")
	[childPath, childValue] := walk(value.resources)

	childValue.name == "authsettings"
	not childValue.properties.enabled

	issue := prepare_issue(childValue)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.resources.name=authsettings%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "resource authsettings should have 'properties.enabled' property set to true",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(childPath, issue.sl),
	}
}

prepare_issue(resource) = issue {
	common_lib.valid_key(resource, "properties")
	common_lib.valid_key(resource.properties, "enabled")
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'enabled' is false on authsettings properties",
		"sk": ".properties.enabled",
		"sl": ["properties", "enabled"],
	}
} else = issue {
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'enabled' is undefined",
		"sk": "",
		"sl": ["name"],
	}
}
