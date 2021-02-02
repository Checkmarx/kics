package Cx

import data.generic.common.isDefaultPassword

#search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	#get all string values from json
	allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
	allStrings = {"key": split(allValues[idd], ":")[0], "value": split(allValues[idd], ":")[1]}

	#remove trailling quotation marks
	correctStrings = {
		"key": substring(allStrings.key, 1, count(allStrings.key) - 2),
		"value": substring(allStrings.value, 1, count(allStrings.value) - 3),
	}

	checkforvulnerability(correctStrings)

	result := {
		"documentId": input.document[id].id,
		"searchKey": sprintf("%s={{%s}}", [correctStrings.key, correctStrings.value]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Hardcoded secret key should not appear in source",
		"keyActualValue": correctStrings.value,
	}
}

isUnderPasswordKey(p) = res {
	ar = {"pas", "psw", "pwd"}
	res := contains(lower(p), ar[_])
}

isUnderSekretKey(p) = res {
	ar = {"secret", "encrypt", "credential"}
	res := contains(lower(p), ar[_])
}

#search for default passwords
checkforvulnerability(correctStrings) {
	isDefaultPassword(correctStrings.value)
	isUnderPasswordKey(correctStrings.key)
}

#search for non-default passwords under known names
checkforvulnerability(correctStrings) {
	#remove short strings
	count(correctStrings.value) > 4
	count(correctStrings.value) < 30

	#password should contain alpha and numeric and not contain spaces
	count(regex.find_n("[a-zA-Z0-9]+", correctStrings.value, -1)) > 0
	not contains(correctStrings.value, "{{")
	isUnderPasswordKey(correctStrings.key)
}

#search for non-default passwords with upper, lower chars and digits
# checkforvulnerability(correctStrings) {
# 	#remove short strings
# 	count(correctStrings.value) > 6
# 	count(correctStrings.value) < 20

# 	#password should contain alpha and numeric and not contain spaces
# 	count(regex.find_n("[a-z]+", correctStrings.value, -1)) > 0
# 	count(regex.find_n("[A-Z]+", correctStrings.value, -1)) > 0
# 	count(regex.find_n("[0-9]+", correctStrings.value, -1)) > 0
# 	count(regex.find_n("^[^\\s]+$", correctStrings.value, -1)) > 0
# }

#search for harcoded secrets with known prefixes
checkforvulnerability(correctStrings) {
	#look for a known prefix
	contains(correctStrings.value, "PRIVATE KEY")
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
	count(regex.find_n("^[^\\s/:@,.-]+$", correctStrings.value, -1)) > 0
}

#search for harcoded secrets by looking for their values with a special chars and length
# checkforvulnerability(correctStrings) {
# 	#remove short strings
# 	count(correctStrings.value) > 30
# 	#remove string with non-keys characters
# 	count(regex.find_n("^[^\\s/:@,.-]+$", correctStrings.value, -1)) > 0
# }
