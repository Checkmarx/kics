package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["configurations", "Microsoft.DBforPostgreSQL/servers/configurations"]

	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.DBforPostgreSQL/servers"
	childrenArr := arm_lib.get_children(doc, value, path)

	children := childrenArr[c].value
	children.type == types[_]
	endswith(children.name, "connection_throttling")

	[c_value, c_type]:= arm_lib.getDefaultValueFromParametersIfPresent(doc, children.properties.value)

	lower(c_value) != "on"

	result := {
		"documentId": input.document[i].id,
		"resourceType": children.type,
		"resourceName": children.name,
		"searchKey": sprintf("%s.name=%s.properties.value", [common_lib.concat_path(childrenArr[c].path), children.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource '%s' should have an 'auditingsettings' %s resource enabled", [c_type, value.name]),
		"keyActualValue": sprintf("resource '%s' doesn't have an 'auditingsettings' resource enabled", [value.name]),
		"searchLine": common_lib.build_search_line(childrenArr[c].path, ["properties", "value"]),
	}
}

CxPolicy[result] {
	types := ["configurations", "Microsoft.DBforPostgreSQL/servers/configurations"]
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers"
	childrenArr := arm_lib.get_children(doc, value, path)
	count([x |
		children := childrenArr[c].value
		children.type == types[_]
		endswith(children.name, "connection_throttling")
		x := children
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource '%s' should have an 'auditingsettings' resource enabled", [value.name]),
		"keyActualValue": sprintf("resource '%s' doesn't have an 'auditingsettings' resource enabled", [value.name]),
		"searchLine": common_lib.build_search_line(path, ["name"]),
	}
}
