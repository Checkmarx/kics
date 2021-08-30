package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cron_job[name]

	not common_lib.valid_key(resource.spec, "starting_deadline_seconds")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_cron_job[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.starting_deadline_seconds is set", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.starting_deadline_seconds is undefined", [name]),
	}
}
