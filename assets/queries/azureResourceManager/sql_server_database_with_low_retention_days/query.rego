package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

types := ["Microsoft.Sql/servers/databases/auditingSettings", "auditingSettings", "Microsoft.Sql/servers/auditingSettings"]
dbTypes := ["Microsoft.Sql/servers/databases", "databases", "Microsoft.Sql/servers"]

CxPolicy[result] {
	doc := input.document[i]
	
	[path, value] = walk(doc)

	value.type == dbTypes[_]
	childrenArr := get_children(doc, value, path)
	
	child := childrenArr.value[_]
	child.type == types[_]

	child_path := childrenArr.path

	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.state)
	lower(val) == "enabled"
	not common_lib.valid_key(child.properties, "retentionDays")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'auditingSettings.properties.retentionDays' should be defined and above 90 days",
		"keyActualValue": "'auditingSettings.properties.retentionDays' is missing",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	
	[path, value] = walk(doc)

	value.type == dbTypes[_]
	childrenArr := get_children(doc, value, path)
	
	child := childrenArr.value[_]
	child.type == types[_]

	child_path := childrenArr.path

	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.state)
	lower(val) == "enabled"
	[val_rd, val_rd_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.retentionDays)
	
    val_rd < 90

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionDays", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'auditingSettings.properties.retentionDays' %s should be defined and above 90 days", [val_rd_type]),
		"keyActualValue": sprintf("'auditingSettings.properties.retentionDays' %s is %d", [val_rd_type, child.properties.retentionDays]),
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionDays"]),
	}
}

get_children(doc, parent, path) = childArr { # nested resources in json format
	common_lib.valid_key(parent, "resources")
    childArr := {"value": parent.resources, "path": array.concat(path, ["resources"])}
} else = childArr { # bicep format (parent keyword)
    not common_lib.valid_key(parent, "resources")
    values := [x |
    	[path_child, value_child] := walk(doc)
        startswith(value_child.name, parent.name)
        value_child.name != parent.name
        x := {"value": value_child, "path": path_child}
    ]
    unique := {y | y := values[_]} 
    childArr := [y | y := unique[_]]
} 