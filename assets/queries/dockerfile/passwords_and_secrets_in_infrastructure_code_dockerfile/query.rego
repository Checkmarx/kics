package Cx

import data.generic.common as commonLib

# search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	docs := input.document[id]
	keyDoc = docs[platform][father]

	#get all string values from json
	allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(keyDoc), -1)

	val := commonLib.replaceUniCode(allValues[m])

	#replace "=" with spaces to check for problems with for the various formats of ENV in dockerfile
	treatedValue := replace(val, "=", " ")
	allStrings := {"key": split(split(treatedValue, ":")[1], " ")[1], "value": split(split(treatedValue, ":")[1], " ")[2]}

	#remove trailling quotation marks
	correctStrings := {
		"key": substring(allStrings.key, 0, count(allStrings.key)),
		"value": substring(allStrings.value, 0, count(allStrings.value) - 2),
		"id": father,
	}

	commonLib.checkforvulnerability(correctStrings)

	result := {
		"documentId": docs.id,
		"searchKey": sprintf("{{%s}}.%s=%s", [correctStrings.id, correctStrings.key, correctStrings.value]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Hardcoded secret key should not appear in source",
		"keyActualValue": correctStrings.value,
	}
}
