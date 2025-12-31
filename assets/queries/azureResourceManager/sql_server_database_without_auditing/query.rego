package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["auditingSettings", "Microsoft.Sql/servers/databases/auditingSettings", "Microsoft.Sql/servers/auditingSettings"]
	dbTypes := ["databases", "Microsoft.Sql/servers/databases", "Microsoft.Sql/servers"]
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == dbTypes[_]

	# Case of database resource with auditingsettings as "child"
	childrenArr_full := get_children(doc, value, path)
	childrenArr := [x | x := childrenArr_full[ch_index]
						childrenArr_full[ch_index].type == types[_]]

	count([x |
		child := childrenArr[_]
		[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.state)
		lower(val) == "enabled"
		x := child
	]) == 0

	# Case of "child" database resource with auditingsettings as "brother" resource
	depth_path := array.slice(path, 0, count(path)-1)
	brothersArr_full := object.get(doc, depth_path, [])
	brothersArr := [x | x := brothersArr_full[ch_index]
						brothersArr_full[ch_index].type == types[_]
						count(split(brothersArr_full[ch_index].name, "/")) < count(split(value.name, "/")) + 2]	# Prevents /servers from capturing ../databases/auditingSettings

	count([x |
		brother := brothersArr[_]
		[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, brother.properties.state)
		lower(val) == "enabled"
		x := brother
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
		"issueType": get_issue_type(childrenArr, brothersArr),
		"keyExpectedValue": sprintf("resource '%s' should have an enabled 'auditingsettings' resource", [value.name]),
		"keyActualValue": sprintf("resource '%s' is missing an enabled 'auditingsettings' resource", [value.name]),
		"searchLine": common_lib.build_search_line(path, ["name"]),
	}
}

get_children(doc, parent, path) = childArr {
	resourceArr := [x | x := parent.resources[_]]
	outerArr := get_outer_children(doc, parent.name)
	childArr := array.concat(resourceArr, outerArr)
}

get_outer_children(doc, nameParent) = outerArr {
	outerArr := [x |
		[path, value] := walk(doc)
		startswith(value.name, nameParent)
        count(split(value.name, "/")) == count(split(nameParent, "/")) + 1 # Prevents /servers from capturing ../databases/auditingSettings
		x := value
	]
}

get_issue_type(childrenArr,brothersArr) = "MissingAttribute"{
	childrenArr == []
	brothersArr == []
} else = "IncorrectValue" # When associated with an auditing resource with "state" != enabled
