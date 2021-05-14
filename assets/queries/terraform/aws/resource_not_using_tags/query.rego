package Cx

import data.generic.terraform as terraform_lib

CxPolicy[result] {
	resource := input.document[i].resource[res][name]
	terraform_lib.check_resource_tags(res)
	object.get(resource, "tags", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}]", [res, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].tags is defined", [res, name]),
		"keyActualValue": sprintf("%s[{{%s}}].tags is missing", [res, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[res][name]
	terraform_lib.check_resource_tags(res)
	tags := remove_name_tag(resource.tags)
	count(tags) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}].tags", [res, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].tags has tags defined other than 'Name'", [res, name]),
		"keyActualValue": sprintf("%s[{{%s}}].tags has no tags defined", [res, name]),
	}
}

remove_name_tag(tags) = res_tags {
	object.get(tags, "Name", "undefined") == "undefined"
	res_tags := tags
} else = res_tags {
	res_tags := object.remove(tags, {"Name"})
}
