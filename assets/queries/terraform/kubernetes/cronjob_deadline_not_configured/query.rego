package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.kubernetes_cron_job[name]

	not common_lib.valid_key(resource.spec, "starting_deadline_seconds")

	result := {
		"documentId": document.id,
		"resourceType": "kubernetes_cron_job",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cron_job[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_cron_job[%s].spec.starting_deadline_seconds should be set", [name]),
		"keyActualValue": sprintf("kubernetes_cron_job[%s].spec.starting_deadline_seconds is undefined", [name]),
	}
}
