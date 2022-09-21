package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	kms := input.document[i].resource.google_kms_crypto_key[name]
	rotation_period := substring(kms.rotation_period, 0, count(kms.rotation_period) - 1)

	seconds_in_a_year := 31536000
	to_number(rotation_period) > seconds_in_a_year

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key",
		"resourceName": tf_lib.get_resource_name(kms, name),
		"searchKey": sprintf("google_kms_crypto_key[%s].rotation_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'rotation_period' must be at most 31536000s",
		"keyActualValue": sprintf("'rotation_period' is %s", [rotation_period]),
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key", name],["rotation_period"]),
		"remediation": json.marshal({
			"before": sprintf("%s",[rotation_period]),
			"after": "100000"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	kms := input.document[i].resource.google_kms_crypto_key[name]

	not kms.rotation_period

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key",
		"resourceName": tf_lib.get_resource_name(kms, name),
		"searchKey": sprintf("google_kms_crypto_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'rotation_period' should be set and is at most 31536000 seconds",
		"keyActualValue": "'rotation_period' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key", name],[]),
		"remediation": "rotation_period = \"100000s\"",
		"remediationType": "addition",
	}
}
