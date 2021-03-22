package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_storage_bucket", "gcp_storage_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	object.get(bucket, "acl", "undefined") == "undefined"
	object.get(bucket, "default_object_acl", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_storage_bucket.default_object_acl is defined",
		"keyActualValue": "gcp_storage_bucket.default_object_acl is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	check(bucket.acl.entity)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.acl.entity", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_storage_bucket.acl.entity isn't 'allUsers' or 'allAuthenticatedUsers'",
		"keyActualValue": "gcp_storage_bucket.acl.entity is 'allUsers' or 'allAuthenticatedUsers'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	object.get(bucket, "acl", "undefined") == "undefined"
	check(bucket.default_object_acl.entity)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.default_object_acl.entity", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_storage_bucket.default_object_acl.entity isn't 'allUsers' or 'allAuthenticatedUsers'",
		"keyActualValue": "gcp_storage_bucket.default_object_acl.entity is 'allUsers' or 'allAuthenticatedUsers'",
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
