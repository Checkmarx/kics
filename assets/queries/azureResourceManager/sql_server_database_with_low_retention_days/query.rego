package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

dbTypes := ["Microsoft.Sql/servers/databases", "databases", "Microsoft.Sql/servers"]
types := ["Microsoft.Sql/servers/databases/auditingSettings", "auditingSettings", "Microsoft.Sql/servers/auditingSettings"]

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == dbTypes[_]
	childrenArr := get_children(doc, value, path)

	child := childrenArr[k].value[i2]
	child.type == types[_]

	child_path := childrenArr[k].path

	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.state)
	lower(val) == "enabled"

	results := invalid_retention_days(doc, child, child_path, i2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": child.type,
		"resourceName": child.name,
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

invalid_retention_days(doc, child, child_path, i2) = results {
	not common_lib.valid_key(child.properties, "retentionDays")
	results := {
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(child_path), child.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'auditingSettings.properties.retentionDays' should be defined and above 90 days",
		"keyActualValue": "'auditingSettings.properties.retentionDays' is missing",
		"searchLine": get_searchLine(child_path, i2, ["properties"])
	}
} else = results {
	[val_rd, val_rd_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.retentionDays)
    val_rd < 90

	results := {
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionDays", [common_lib.concat_path(child_path), child.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'auditingSettings.properties.retentionDays' %s should be defined and above 90 days", [val_rd_type]),
		"keyActualValue": sprintf("'auditingSettings.properties.retentionDays' %s is %d", [val_rd_type, child.properties.retentionDays]),
		"searchLine": get_searchLine(child_path, i2, ["properties", "retentionDays"])
	}
}

get_searchLine(path,index,path_to_field) = sk {
	is_number(path[count(path) - 1])
    sk := common_lib.build_search_line(path, path_to_field)
} else = sk {
	 sk := common_lib.build_search_line(path, array.concat([index],path_to_field))
}

get_children(doc, parent, path) = childArr {
	common_lib.valid_key(parent, "resources")
    childArr := [{"value": parent.resources, "path": array.concat(path, ["resources"])}]
} else = childArr {
	not common_lib.valid_key(parent, "resources")
	values := [x |
		[path_child, value_child] := walk(doc)
		value_child.name != parent.name
		common_lib.valid_key(value_child, "dependsOn")
		d := value_child.dependsOn[_]
		contains(d, parent.type)
		contains(d, parent.name)
		x := {"value": [value_child], "path": path_child}
	]
	count(values) > 0
	unique := {y | y := values[_]}
	childArr := [y | y := unique[_]]
}
