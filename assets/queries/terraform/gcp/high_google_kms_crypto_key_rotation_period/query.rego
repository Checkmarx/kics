package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cryptoKey := input.document[i].resource.google_kms_crypto_key[name]
	rotationP := substring(cryptoKey.rotation_period, 0, count(cryptoKey.rotation_period) - 1)
	to_number(rotationP) > 7776000

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key",
		"resourceName": tf_lib.get_resource_name(cryptoKey, name),
		"searchKey": sprintf("resource.google_kms_crypto_key[%s].rotation_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'google_kms_crypto_key.rotation_period' is less or equal to 7776000",
		"keyActualValue": "'google_kms_crypto_key.rotation_period' is higher than 7776000",
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key", name, "rotation_period"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [rotationP]) ,
			"after": "100000"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	cryptoKey := input.document[i].resource.google_kms_crypto_key[name]

	not common_lib.valid_key(cryptoKey,"rotation_period")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key",
		"resourceName": tf_lib.get_resource_name(cryptoKey, name),
		"searchKey": sprintf("resource.google_kms_crypto_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'google_kms_crypto_key.rotation_period' is set",
		"keyActualValue": "'google_kms_crypto_key.rotation_period' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key", name], []),
		"remediation": "rotation_period = \"100000s\"",
		"remediationType": "addition",
	}
}
