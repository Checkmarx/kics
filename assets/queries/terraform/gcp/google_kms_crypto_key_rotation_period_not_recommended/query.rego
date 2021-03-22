package Cx

CxPolicy[result] {
	cryptoKey := input.document[i].resource.google_kms_crypto_key[name]
	rotationP := substring(cryptoKey.rotation_period, 0, count(cryptoKey.rotation_period) - 1)
	to_number(rotationP) > 7776000

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.google_kms_crypto_key[%s].rotation_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'google_kms_crypto_key.rotation_period' is less or equal to 7776000",
		"keyActualValue": "'google_kms_crypto_key.rotation_period' is higher than 7776000",
	}
}

CxPolicy[result] {
	cryptoKey := input.document[i].resource.google_kms_crypto_key[name]

	object.get(cryptoKey,"rotation_period","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.google_kms_crypto_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'google_kms_crypto_key.rotation_period' is set",
		"keyActualValue": "'google_kms_crypto_key.rotation_period' is undefined",
	}
}
