package Cx

import data.generic.common as commonLib

# search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	docs := input.document[_]

	[path, value] = walk(docs)
	is_string(value)
	value = replace_unicode(value)
	checkObjects := prepare_object(path[minus(count(path), 1)], value)
	checkObject := checkObjects[_]
	check_vulnerability(checkObject)
	allPath := [x | merge_path(path[i]) != ""; x := merge_path(path[i])]
	result := {
		"documentId": docs.id,
		"searchKey": resolve_path(checkObject, allPath),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Hardcoded secret key should not appear in source",
		"keyActualValue": value,
	}
}

merge_path(pathItem) = item {
	not is_string(pathItem)
	item := ""
} else = item {
	clearParse := ["playbooks", "tasks", "command", "original"]
	commonLib.equalsOrInArray(clearParse, lower(pathItem))
	item := ""
} else = item {
	contains(pathItem, ".")
	item := sprintf("{{%s}}", [pathItem])
} else = item {
	item := pathItem
}

resolve_path(obj, path) = resolved {
	obj.id != ""
	resolved := sprintf("FROM=%s.{{%s}}", [concat(".", path), obj.id])
} else = resolved {
	resolved := concat(".", path)
}

prepare_object(key, value) = obj {
	#dockerfile
	key == "Original"
	args := split(value, " ")
	obj := [x | x := create_docker_object(args[_], value)]
} else = obj {
	obj := [{
		"key": key,
		"value": value,
		"id": "",
	}]
}

create_docker_object(value, original) = obj {
	contains(value, "=")
	splitted := split(value, "=")
	count(splitted) > 1
	k := splitted[0]
	is_string(k)
	v := concat("", array.slice(splitted, 1, count(splitted)))
	obj := {
		"key": k,
		"value": v,
		"id": original,
	}
}

is_under_password_key(p) {
	ar = {"pas", "psw", "pwd"}
	contains(lower(p), ar[_])
}

is_under_secret_key(p) = res {
	ar = {"secret", "encrypt", "credential"}
	res := contains(lower(p), ar[_])
}

#search for default passwords
check_vulnerability(correctStrings) {
	commonLib.isDefaultPassword(correctStrings.value)
	is_under_password_key(correctStrings.key)

	#remove common key and values
	check_common(correctStrings)
}

#search for non-default passwords under known names
check_vulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 4
	count(correctStrings.value) < 30

	#password should contain alpha and numeric and not contain spaces
	count(regex.find_n("[a-zA-Z0-9]+", correctStrings.value, -1)) > 0
	count(regex.find_n("^[^{{]+$", correctStrings.value, -1)) > 0
	is_under_password_key(correctStrings.key)

	#remove common key and values
	check_common(correctStrings)
}

#search for non-default passwords with upper, lower chars and digits
check_vulnerability(correctStrings) { #ignore ascii cases
	#remove short strings
	count(correctStrings.value) > 6
	count(correctStrings.value) < 20

	#password should contain alpha and numeric and not contain spaces or underscores
	count(regex.find_n("[a-z]+", correctStrings.value, -1)) > 0
	count(regex.find_n("[A-Z]+", correctStrings.value, -1)) > 0
	count(regex.find_n("[0-9]+", correctStrings.value, -1)) > 0
	count(regex.find_n("^[^\\s_]+", correctStrings.value, -1)) > 0

	#remove common key and values
	check_common(correctStrings)
}

#search for harcoded secrets with known prefixes
check_vulnerability(correctStrings) {
	#look for a known prefix
	contains(correctStrings.value, "PRIVATE KEY")

	#remove common key and values
	check_common(correctStrings)
}

#search for harcoded secret keys under known names
check_vulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 8

	#remove string with non-keys characters
	count(regex.find_n("^[^\\s$]+$", correctStrings.value, -1)) > 0

	#look for a known names
	is_under_secret_key(correctStrings.key)

	#remove string with non-keys characters
	count(regex.find_n("^[^\\s/:@,.-_|]+$", correctStrings.value, -1)) > 0

	#remove common key and values
	check_common(correctStrings)
}

#search for harcoded secrets by looking for their values with a special chars and length
check_vulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 30

	#remove string with non-keys characters
	count(regex.find_n("^[^\\s/:@,.-_|]+$", correctStrings.value, -1)) > 0

	#remove common key and values
	check_common(correctStrings)
}

check_common(correctStrings) {
	#remove common values
	not commonLib.isCommonValue(correctStrings.value)

	#remove common keys
	not commonLib.isCommonKey(correctStrings.key)
}

#replace unicode values to avoid false positives
replace_unicode(allValues) = treatedValue {
	treatedValue_first := replace(allValues, "\\u003c", "<")
	treatedValue = replace(treatedValue_first, "\\u003e", ">")
}
