package Cx

import data.generic.common as common_lib
import data.generic.terraform as terraform_lib

CxPolicy[result] {
	resource := input.document[i].resource[res][name]
	terraform_lib.check_resource_tags(res)
	not common_lib.valid_key(resource, "tags")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}]", [res, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].tags is defined and not null", [res, name]),
		"keyActualValue": sprintf("%s[{{%s}}].tags is undefined or null", [res, name]),
		"searchLine": common_lib.build_search_line(["resource", res, name], []),
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
		"searchLine": common_lib.build_search_line(["resource", res, name, "tags"], []),
	}
}

remove_name_tag(tags) = res_tags {
	not common_lib.valid_key(tags, "Name")
	res_tags := tags
} else = res_tags {
	res_tags := object.remove(tags, {"Name"})
}
