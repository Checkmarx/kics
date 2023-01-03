package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	sslPolicy := input.document[i].resource.google_compute_ssl_policy[name]
	sslPolicy.min_tls_version != "TLS_1_2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_ssl_policy",
		"resourceName": tf_lib.get_resource_name(sslPolicy, name),
		"searchKey": sprintf("google_compute_ssl_policy[%s].min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_ssl_policy[%s].min_tls_version should be TLS_1_2", [name]),
		"keyActualValue": sprintf("google_compute_ssl_policy[%s].min_tls_version is not TLS_1_2", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_ssl_policy", name],["min_tls_version"]),
		"remediation": json.marshal({
			"before": sprintf("%s",[sslPolicy.min_tls_version]),
			"after": "TLS_1_2"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	sslPolicy := input.document[i].resource.google_compute_ssl_policy[name]
	not common_lib.valid_key(sslPolicy, "min_tls_version")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_ssl_policy",
		"resourceName": tf_lib.get_resource_name(sslPolicy, name),
		"searchKey": sprintf("google_compute_ssl_policy[%s].min_tls_version", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_ssl_policy[%s].min_tls_version should be TLS_1_2", [name]),
		"keyActualValue": sprintf("google_compute_ssl_policy[%s].min_tls_version is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_ssl_policy", name],[]),
		"remediation": "min_tls_version = \"TLS_1_2\"",
		"remediationType": "addition",
	}
}
