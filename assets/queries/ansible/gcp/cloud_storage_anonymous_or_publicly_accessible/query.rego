package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["google.cloud.gcp_storage_bucket"]

	ansLib.checkState(bucket)
	object.get(bucket, "acl", "undefined") == "undefined"
	object.get(bucket, "default_object_acl", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_storage_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_storage_bucke}}t.default_object_acl is defined",
		"keyActualValue": "{{google.cloud.gcp_storage_bucket}}.default_object_acl is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["google.cloud.gcp_storage_bucket"]

	ansLib.checkState(bucket)
	check(bucket.acl.entity)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_storage_bucket}}.acl.entity", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_storage_bucket}}.acl.entity isn't 'allUsers' or 'allAuthenticatedUsers'",
		"keyActualValue": "{{google.cloud.gcp_storage_bucket}}.acl.entity is 'allUsers' or 'allAuthenticatedUsers'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["google.cloud.gcp_storage_bucket"]

	ansLib.checkState(bucket)
	object.get(bucket, "acl", "undefined") == "undefined"
	check(bucket.default_object_acl.entity)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_storage_bucket}}.default_object_acl.entity", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_storage_bucket}}.default_object_acl.entity isn't 'allUsers' or 'allAuthenticatedUsers'",
		"keyActualValue": "{{google.cloud.gcp_storage_bucket}}.default_object_acl.entity is 'allUsers' or 'allAuthenticatedUsers'",
	}
}

check(entity) {
	is_string(entity)
	lower(entity) == "allusers"
}

check(entity) {
	is_string(entity)
	lower(entity) == "allauthenticatedusers"
}
