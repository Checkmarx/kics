package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["auditingSettings", "Microsoft.Sql/servers/databases/auditingSettings"]
	dbTypes := ["Microsoft.Sql/servers/databases", "databases"]

	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == dbTypes[_]
	childrenArr := arm_lib.get_children(doc, value)

	count([x |
		child := childrenArr[_]
		child.type == types[_]
		lower(child.properties.state) == "enabled"
		x := child
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource '%s' has an 'auditingsettings' resource enabled", [value.name]),
		"keyActualValue": sprintf("resource '%s' doesn't have an 'auditingsettings' resource enabled", [value.name]),
	}
}
