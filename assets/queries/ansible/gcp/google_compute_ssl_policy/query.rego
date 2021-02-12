package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	policy := task["google.cloud.gcp_compute_ssl_policy"]

	ansLib.checkState(policy)
	object.get(policy, "min_tls_version", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_ssl_policy}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_ssl_policy}} has min_tls_version set to 'TLS_1_2'",
		"keyActualValue": "{{google.cloud.gcp_compute_ssl_policy}} does not have min_tls_version set to 'TLS_1_2'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	policy := task["google.cloud.gcp_compute_ssl_policy"]

	ansLib.checkState(policy)
	policy.min_tls_version != "TLS_1_2"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_ssl_policy}}.min_tls_version", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_ssl_policy}}.min_tls_version has min_tls_version set to 'TLS_1_2'",
		"keyActualValue": "{{google.cloud.gcp_compute_ssl_policy}}.min_tls_version does not have min_tls_version set to 'TLS_1_2'",
	}
}
