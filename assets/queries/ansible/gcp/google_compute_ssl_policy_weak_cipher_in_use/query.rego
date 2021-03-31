package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_compute_ssl_policy", "gcp_compute_ssl_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	object.get(policy, "min_tls_version", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_ssl_policy has min_tls_version set to 'TLS_1_2'",
		"keyActualValue": "gcp_compute_ssl_policy does not have min_tls_version set to 'TLS_1_2'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	policy := task[modules[m]]
	ansLib.checkState(policy)

	policy.min_tls_version != "TLS_1_2"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.min_tls_version", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_ssl_policy.min_tls_version has min_tls_version set to 'TLS_1_2'",
		"keyActualValue": "gcp_compute_ssl_policy.min_tls_version does not have min_tls_version set to 'TLS_1_2'",
	}
}
