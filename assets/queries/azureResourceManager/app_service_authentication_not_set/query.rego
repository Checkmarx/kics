package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib


# Check outside parent resource
CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites/config"
	endswith(value.name, "authsettings")
	arm_lib.isDisabledOrUndefined(doc, value.properties, "enabled")

	issue := prepare_issue(doc,value)

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
	arm_lib.isDisabledOrUndefined(doc, childValue.properties, "enabled")

	issue := prepare_issue(doc, childValue)

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

prepare_issue(doc, resource) = issue {
	common_lib.valid_key(resource, "properties")
	[_ , type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, resource.properties.enabled)
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'enabled' %s is false on authsettings properties",[type]),
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
