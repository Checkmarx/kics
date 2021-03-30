package Cx

import data.generic.common as commonLib

# search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	docs := input.document[id]
	keyDoc = docs[platform][father]

	platform == "resource"

	#get all string values from json
	allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(keyDoc), -1)

	val := commonLib.replaceUniCode(allValues[m])

	allStrings = {"key": split(val, "\":")[0], "value": split(val, "\":")[1]}

	#remove trailling quotation marks
	correctStrings = {
		"key": substring(allStrings.key, 1, count(allStrings.key) - 1),
		"value": substring(allStrings.value, 1, count(allStrings.value) - 3),
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
