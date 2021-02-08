package Cx

import data.generic.common as commonLib

# search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	#get all string values from json
	allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)

	correctStrings := getCorrectStrings(replaceUniCode(allValues[_]))

	checkforvulnerability(correctStrings)

	result := {
		"documentId": input.document[id].id,
		"searchKey": sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Hardcoded secret key should not appear in source",
		"keyActualValue": correctStrings.value,
	}
}

isUnderPasswordKey(p) {
	ar = {"pas", "psw", "pwd"}
	contains(lower(p), ar[_])
}

isUnderSekretKey(p) = res {
	ar = {"secret", "encrypt", "credential"}
	res := contains(lower(p), ar[_])
}

#search for default passwords
checkforvulnerability(correctStrings) {
	commonLib.isDefaultPassword(correctStrings.value)
	isUnderPasswordKey(correctStrings.key)

	#remove common key and values
	checkCommon(correctStrings)
}

#search for non-default passwords under known names
checkforvulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 4
	count(correctStrings.value) < 30

	#password should contain alpha and numeric and not contain spaces
	count(regex.find_n("[a-zA-Z0-9]+", correctStrings.value, -1)) > 0
	count(regex.find_n("^[^{{]+$", correctStrings.value, -1)) > 0
	isUnderPasswordKey(correctStrings.key)

	#remove common key and values
	checkCommon(correctStrings)
}

#search for non-default passwords with upper, lower chars and digits
checkforvulnerability(correctStrings) { #ignore ascii cases
	#remove short strings
	count(correctStrings.value) > 6
	count(correctStrings.value) < 20

	#password should contain alpha and numeric and not contain spaces or underscores
	count(regex.find_n("[a-z]+", correctStrings.value, -1)) > 0
	count(regex.find_n("[A-Z]+", correctStrings.value, -1)) > 0
	count(regex.find_n("[0-9]+", correctStrings.value, -1)) > 0
	count(regex.find_n("^[^\\s_]+$", correctStrings.value, -1)) > 0

	#remove common key and values
	checkCommon(correctStrings)
}

#search for harcoded secrets with known prefixes
checkforvulnerability(correctStrings) {
	#look for a known prefix
	contains(correctStrings.value, "PRIVATE KEY")

	#remove common key and values
	checkCommon(correctStrings)
}

#search for harcoded secret keys under known names
checkforvulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 8

	#remove string with non-keys characters
	count(regex.find_n("^[^\\s$]+$", correctStrings.value, -1)) > 0

	#look for a known names
	isUnderSekretKey(correctStrings.key)

	#remove string with non-keys characters
	count(regex.find_n("^[^\\s/:@,.-_|]+$", correctStrings.value, -1)) > 0

	#remove common key and values
	checkCommon(correctStrings)
}

#search for harcoded secrets by looking for their values with a special chars and length
checkforvulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 30

	#remove string with non-keys characters
	count(regex.find_n("^[^\\s/:@,.-_|]+$", correctStrings.value, -1)) > 0

	#remove common key and values
	checkCommon(correctStrings)
}

checkCommon(correctStrings) {
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

#construct correct strings based on dockerfile or other platform
getCorrectStrings(allValues) = correctStrings {
	#other platforms
	not contains(split(allValues, "\":")[0], "Original")
	allStrings = {"key": split(allValues, "\":")[0], "value": split(allValues, "\":")[1]}

	#remove trailling quotation marks
	correctStrings = {
		"key": substring(allStrings.key, 1, count(allStrings.key) - 1),
		"value": substring(allStrings.value, 1, count(allStrings.value) - 3),
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
	}
}
