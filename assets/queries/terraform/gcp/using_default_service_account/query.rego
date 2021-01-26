package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	object.get(resource, "service_account", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account' is defined", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	object.get(resource.service_account, "email", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].service_account", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' is defined", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	count(resource.service_account.email) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' is not empty", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is empty", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	count(resource.service_account.email) > 0
	not contains(resource.service_account.email, "@")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' is not an email", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is an email", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	contains(resource.service_account.email, "@developer.gserviceaccount.com")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' is not a default Google Compute Engine service account", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is a default Google Compute Engine service account", [name]),
	}
}
