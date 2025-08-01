package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["auditingSettings", "Microsoft.Sql/servers/databases/auditingSettings", "Microsoft.Sql/servers/auditingSettings"]
	dbTypes := ["Microsoft.Sql/servers/databases", "databases", "Microsoft.Sql/servers"]

	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == dbTypes[_]
	childrenArr := arm_lib.get_children(doc, value, path)

	count([x |
		child := childrenArr[_].value
		child.type == types[_]
		[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.state)
		lower(val) == "enabled"
		x := child
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource '%s' should have an enabled 'auditingsettings' resource", [value.name]),
		"keyActualValue": sprintf("resource '%s' is missing an enabled 'auditingsettings' resource", [value.name]),
		"searchLine": common_lib.build_search_line(path, ["name"]),
	}
}
