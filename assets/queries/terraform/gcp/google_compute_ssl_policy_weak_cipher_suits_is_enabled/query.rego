package Cx

CxPolicy[result] {
	sslPolicy := input.document[i].resource.google_compute_ssl_policy[name]
	sslPolicy.min_tls_version != "TLS_1_2"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_ssl_policy[%s].min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_ssl_policy[%s].min_tls_version is TLS_1_2", [name]),
		"keyActualValue": sprintf("google_compute_ssl_policy[%s].min_tls_version is not TLS_1_2", [name]),
	}
}

CxPolicy[result] {
	sslPolicy := input.document[i].resource.google_compute_ssl_policy[name]
	object.get(sslPolicy, "min_tls_version", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_ssl_policy[%s].min_tls_version", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_ssl_policy[%s].min_tls_version is TLS_1_2", [name]),
		"keyActualValue": sprintf("google_compute_ssl_policy[%s].min_tls_version is undefined", [name]),
	}
}
