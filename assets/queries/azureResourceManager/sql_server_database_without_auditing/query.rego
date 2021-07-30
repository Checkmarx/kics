package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["auditingSettings", "Microsoft.Sql/servers/databases/auditingSettings"]
	dbTypes := ["Microsoft.Sql/servers/databases", "databases"]

	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == dbTypes[_]
	childrenArr := arm_lib.get_children(doc, value, path)

	count([x |
		child := childrenArr[_].value
		child.type == types[_]
		lower(child.properties.state) == "enabled"
		x := child
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource '%s' has an enabled 'auditingsettings' resource", [value.name]),
		"keyActualValue": sprintf("resource '%s' is missing an enabled 'auditingsettings' resource", [value.name]),
	}
}
