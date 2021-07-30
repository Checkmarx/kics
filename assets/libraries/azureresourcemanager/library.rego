package generic.azureresourcemanager

# get_children returns an Array of all children of the resource
# doc is input.document[i]
# parent is the parent resource
get_children(doc, parent, path) = childArr {
	resourceArr := [x | x := {"value": parent.resources[_], "path": array.concat(path, ["resources"])}]
	outerArr := get_outer_children(doc, parent.name)
	childArr := array.concat(resourceArr, outerArr)
}

get_outer_children(doc, nameParent) = outerArr {
	outerArr := [x |
		[path, value] := walk(doc)
		startswith(value.name, nameParent)
		value.name != nameParent
		x := {"value": value, "path": path}
	]
}
