package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["auditingSettings", "Microsoft.Sql/servers/databases/auditingSettings", "Microsoft.Sql/servers/auditingSettings"]
	doc := input.document[i]

	# Use auxiliary function instead of walk
	db_resources := sql_database_resources(doc)
	db_resource := db_resources[_]
	value := db_resource.value
	path := db_resource.path

	# Case of database resource with auditingsettings as "child"
	childrenArr_full := get_children(doc, value, path)
	childrenArr := [x | x := childrenArr_full[ch_index]
						childrenArr_full[ch_index].type == types[_]]

	# Case of "child" database resource with auditingsettings as "brother" resource
	depth_path := array.slice(path, 0, count(path)-1)
	brothersArr_full := object.get(doc, depth_path, [])
	brothersArr := [x | x := brothersArr_full[ch_index]
						brothersArr_full[ch_index].type == types[_]
						count(split(brothersArr_full[ch_index].name, "/")) < count(split(value.name, "/")) + 2]	# Prevents /servers from capturing ../databases/auditingSettings

	dependencyToken := get_dependency_token(value)
	dependentArr := get_dependent_resources(doc, types, value.type, dependencyToken)

	linkedArr := array.concat(array.concat(childrenArr, brothersArr), dependentArr)

	not server_exempted_via_audited_database(doc, db_resources, value, path, linkedArr, types)

	count([x |
		linked := linkedArr[_]
		[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, linked.properties.state)
		lower(val) == "enabled"
		x := linked
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
		"issueType": get_issue_type(linkedArr),
		"keyExpectedValue": sprintf("resource '%s' should have an enabled 'auditingsettings' resource", [value.name]),
		"keyActualValue": sprintf("resource '%s' is missing an enabled 'auditingsettings' resource", [value.name]),
		"searchLine": common_lib.build_search_line(path, ["name"]),
	}
}

# helper function to get SQL database resources without using walk
sql_database_resources(doc) = result {
	dbTypes := ["databases", "Microsoft.Sql/servers/databases", "Microsoft.Sql/servers"]

	# Root resources
	root_resources := [{"value": resource, "path": ["resources", idx]} |
		resource := doc.resources[idx]
		resource.type == dbTypes[_]
	]

	# One level nested resources (in this query it could be databases inside servers)
	nested_l1 := [{"value": resource, "path": ["resources", idx, "resources", idx2]} |
		parent := doc.resources[idx]
		resource := parent.resources[idx2]
		resource.type == dbTypes[_]
	]

	# Two levels nested resources (in this query it could be databases inside servers inside auditingSettings)
	nested_l2 := [{"value": resource, "path": ["resources", idx, "resources", idx2, "resources", idx3]} |
		parent := doc.resources[idx]
		child := parent.resources[idx2]
		resource := child.resources[idx3]
		resource.type == dbTypes[_]
	]

	# resources inside template (some json templates have resources inside properties.template.resources)
	template_resources := [{"value": resource, "path": ["resources", idx]} |
		resource := doc.properties.template.resources[idx]
		resource.type == dbTypes[_]
	]

	result := array.concat(array.concat(array.concat(root_resources, nested_l1), nested_l2), template_resources)
}

get_children(doc, parent, path) = childArr {
	resourceArr := [x | x := parent.resources[_]]
	outerArr := get_outer_children_resources(doc, parent.name)
	childArr := array.concat(resourceArr, outerArr)
}

# Auxiliary function to get outer children without using walk
get_outer_children_resources(doc, nameParent) = result {
	# root resources
	root_children := [resource |
		resource := doc.resources[_]
		startswith(resource.name, nameParent)
		resource.name != nameParent
		count(split(resource.name, "/")) == count(split(nameParent, "/")) + 1
	]

	# one level nested resources
	nested_l1_children := [resource |
		parent := doc.resources[_]
		resource := parent.resources[_]
		startswith(resource.name, nameParent)
		resource.name != nameParent
		count(split(resource.name, "/")) == count(split(nameParent, "/")) + 1
	]

	# two levels nested resources
	nested_l2_children := [resource |
		parent := doc.resources[_]
		child := parent.resources[_]
		resource := child.resources[_]
		startswith(resource.name, nameParent)
		resource.name != nameParent
		count(split(resource.name, "/")) == count(split(nameParent, "/")) + 1
	]

	result := array.concat(array.concat(root_children, nested_l1_children), nested_l2_children)
}

get_issue_type(linkedArr) = "MissingAttribute" {
	linkedArr == []
} else = "IncorrectValue" # When associated with an auditing resource with "state" != enabled

is_child_database(serverValue, serverPath, dbValue, dbPath) {
	count(dbPath) > count(serverPath)
	array.slice(dbPath, 0, count(serverPath)) == serverPath
} else {
	dep := dbValue.dependsOn[_]
	type_referenced_in_dependency(dep, serverValue.type)
	serverToken := get_dependency_token(serverValue)
	contains(dep, serverToken)
}

server_exempted_via_audited_database(doc, db_resources, value, path, linkedArr, types) {
	value.type == "Microsoft.Sql/servers"
	linkedArr == []

	db_candidate := db_resources[_]
	dbValue := db_candidate.value
	dbPath := db_candidate.path
	dbValue.type != "Microsoft.Sql/servers"
	is_child_database(value, path, dbValue, dbPath)

	# Same "child"/"brother"/"dependsOn" matching as above, but for the candidate database
	dbChildrenArr_full := get_children(doc, dbValue, dbPath)
	dbChildrenArr := [x | x := dbChildrenArr_full[ch_index]
						dbChildrenArr_full[ch_index].type == types[_]]

	dbDepth_path := array.slice(dbPath, 0, count(dbPath)-1)
	dbBrothersArr_full := object.get(doc, dbDepth_path, [])
	dbBrothersArr := [x | x := dbBrothersArr_full[ch_index]
						dbBrothersArr_full[ch_index].type == types[_]
						count(split(dbBrothersArr_full[ch_index].name, "/")) < count(split(dbValue.name, "/")) + 2]

	dbDependencyToken := get_dependency_token(dbValue)
	dbDependentArr := get_dependent_resources(doc, types, dbValue.type, dbDependencyToken)

	child := array.concat(array.concat(dbChildrenArr, dbBrothersArr), dbDependentArr)[_]
	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child.properties.state)
	lower(val) == "enabled"
}

get_dependency_token(resource) = token {
	token := sprintf("parameters('%s')", [arm_lib.isParameterReference(resource.name)])
} else = token {
	token := resource.name
}

leaf_type(resourceType) = leaf {
	parts := split(resourceType, "/")
	leaf := parts[count(parts)-1]
}

type_referenced_in_dependency(dependsOnEntry, resourceType) {
	leaf := leaf_type(resourceType)
	contains(dependsOnEntry, sprintf("/%s'", [leaf]))
} else {
	leaf := leaf_type(resourceType)
	contains(dependsOnEntry, sprintf("('%s'", [leaf]))
}

get_dependent_resources(doc, types, parentType, token) = result {
	root := [x | x := doc.resources[_]]
	nested_l1 := [x | parent := doc.resources[_]; x := parent.resources[_]]
	nested_l2 := [x | parent := doc.resources[_]; child := parent.resources[_]; x := child.resources[_]]
	template := [x | x := doc.properties.template.resources[_]]
	candidates := array.concat(array.concat(array.concat(root, nested_l1), nested_l2), template)

	result := [item |
		item := candidates[_]
		item.type == types[_]
		dep := item.dependsOn[_]
		type_referenced_in_dependency(dep, parentType)
		contains(dep, token)
	]
}
