package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	not common_lib.valid_key(resource, "service_account")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	not common_lib.valid_key(resource.service_account, "email")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s].service_account", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	count(resource.service_account.email) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' should not be empty", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is empty", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	count(resource.service_account.email) > 0
	not contains(resource.service_account.email, "@")
    not emailInVar(resource.service_account.email)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' should not be an email", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is an email", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	contains(resource.service_account.email, "@developer.gserviceaccount.com")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' should not be a default Google Compute Engine service account", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is a default Google Compute Engine service account", [name]),
	}
}

emailInVar(email) {
    startswith(email,"${google_service_account.")
    endswith(email,".email}")
}
