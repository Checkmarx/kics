package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	dt := document.resource.google_compute_instance[appserver]
	dt.can_ip_forward == true

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(dt, appserver),
		"searchKey": sprintf("google_compute_instance[%s].can_ip_forward", [appserver]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'can_ip_forward' should be set to false or Attribute 'can_ip_forward' should be undefined",
		"keyActualValue": "Attribute 'can_ip_forward' is true",
		"searchLine": common_lib.build_search_line(["resource", "google_compute_instance", appserver], ["can_ip_forward"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
