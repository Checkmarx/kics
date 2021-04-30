package Cx

import data.generic.common as commonLib

# search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	docs := input.document[_]

	[path, value] = walk(docs)
	is_string(value)
	value = replaceUniCode(value)
	checkObject := prepare_object(key, value)

	check_vulnerability(checkObject)
	result := {
		"documentId": docs.id,
		"searchKey": sprintf("%s", [concat(".", path)]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Hardcoded secret key should not appear in source",
		"keyActualValue": value,
	}
}

prepare_object(key, value) = obj {
	contains(value, "=")

	obj := {
		"key": path[minus(count(path), 1)],
		"value": value,
	}
}

prepare_object(key, value) = obj {
	obj := {
		"key": path[minus(count(path), 1)],
		"value": value,
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
replaceUniCode(allValues) = treatedValue {
	treatedValue_first := replace(allValues, "\\u003c", "<")
	treatedValue = replace(treatedValue_first, "\\u003e", ">")
}

#this will be removed, but still needs as example
#construct correct strings based on dockerfile or other platform
getCorrectStrings(allValues, name) = correctStrings {
	#other platforms
	not contains(split(allValues, "\":")[0], "Original")
	allStrings = {"key": split(allValues, "\":")[0], "value": split(allValues, "\":")[1]}

	#remove trailling quotation marks
	correctStrings = {
		"key": substring(allStrings.key, 1, count(allStrings.key) - 1),
		"value": substring(allStrings.value, 1, count(allStrings.value) - 3),
		"id": name,
	}
} else = correctStrings {
	#dockerfile
	contains(split(allValues, "\":")[0], "Original")

	#replace "=" with spaces to check for problems with for the various formats of ENV in dockerfile
	treatedValue := replace(allValues, "=", " ")
	allStrings := {"key": split(split(treatedValue, ":")[1], " ")[1], "value": split(split(treatedValue, ":")[1], " ")[2]}

	#remove trailling quotation marks
	correctStrings := {
		"key": substring(allStrings.key, 0, count(allStrings.key)),
		"value": substring(allStrings.value, 0, count(allStrings.value) - 2),
		"id": name,
	}
}
