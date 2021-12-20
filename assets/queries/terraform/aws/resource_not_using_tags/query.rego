package Cx

import data.generic.common as common_lib
import data.generic.terraform as terraform_lib

CxPolicy[result] {
	resource := input.document[i].resource[res][name]
	terraform_lib.check_resource_tags(res)

	check_default_tags == false
	not common_lib.valid_key(resource, "tags")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}]", [res, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].tags is defined and not null", [res, name]),
		"keyActualValue": sprintf("%s[{{%s}}].tags is undefined or null", [res, name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[res][name]
	terraform_lib.check_resource_tags(res)

	check_default_tags == false
	not check_different_tag(resource.tags)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}].tags", [res, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].tags has tags defined other than 'Name'", [res, name]),
		"keyActualValue": sprintf("%s[{{%s}}].tags has no tags defined", [res, name]),
	}
}

check_different_tag(tags) {
	tags[x]
	x != "Name"
}

check_default_tags {
	common_lib.valid_key(input.document[_].provider[_].default_tags, "tags")
} else = false {
	true
}
