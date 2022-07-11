package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	dt := input.document[i].data.google_compute_instance[appserver]
	dt.can_ip_forward == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(dt, appserver),
		"searchKey": sprintf("google_compute_instance[%s]", [appserver]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'can_ip_forward' should be set to false or Attribute 'can_ip_forward' is undefined",
		"keyActualValue": "Attribute 'can_ip_forward' is true",
	}
}
