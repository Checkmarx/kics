package Cx

import data.generic.common as common_lib

# IP Ranges are not implemented (apiVersion < 2019-02-01)
CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.ContainerService/managedClusters"
	is_invalid_api_version(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.apiVersion", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'apiVersion' should be '2019-02-01' or newer",
		"keyActualValue": sprintf("'apiVersion' is %s", [value.apiVersion]),
		"searchLine": common_lib.build_search_line(path, ["apiVersion"]),
	}
}

# IP Ranges initial implementation (2019-02-01 <= apiVersion <= 2019-06-01)
CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.ContainerService/managedClusters"
	is_old_valid_api_version(value)
	not is_old_ip_range_implemented(value)

	issue := prepare_issue_old_api(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'apiServerAuthorizedIPRanges' should be a defined as an array",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

# IP Ranges actual implementation (2019-06-01 < apiVersion)
CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.ContainerService/managedClusters"
	not is_invalid_api_version(value)
	not is_old_valid_api_version(value)

	not is_modern_ip_range_implemented(value)

	issue := prepare_issue_new_api(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'apiServerAccessProfile.authorizedIPRanges' should be defined as an array",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

is_invalid_api_version(value) {
	invalidAPIs := ["2017-08-31", "2018-03-31"]
	value.apiVersion == invalidAPIs[_]
}

is_old_valid_api_version(value) {
	oldAPIs := ["2019-02-01", "2019-04-01", "2019-06-01"]
	value.apiVersion == oldAPIs[_]
}

array_is_filled(arr) {
	is_array(arr)
	count(arr) > 0
}

is_old_ip_range_implemented(value) {
	common_lib.valid_key(value.properties, "apiServerAuthorizedIPRanges")
	array_is_filled(value.properties.apiServerAuthorizedIPRanges)
}

is_modern_ip_range_implemented(value) {
	common_lib.valid_key(value.properties, "apiServerAccessProfile")
	common_lib.valid_key(value.properties.apiServerAccessProfile, "authorizedIPRanges")
	array_is_filled(value.properties.apiServerAccessProfile.authorizedIPRanges)
}

prepare_issue_old_api(resource) = issue {
	common_lib.valid_key(resource.properties, "apiServerAuthorizedIPRanges")
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'apiServerAuthorizedIPRanges' is empty",
		"sk": ".properties.apiServerAuthorizedIPRanges",
		"sl": ["properties", "apiServerAuthorizedIPRanges"],
	}
} else = issue {
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'apiServerAuthorizedIPRanges' is undefined",
		"sk": "",
		"sl": ["name"],
	}
}

prepare_issue_new_api(value) = issue {
	common_lib.valid_key(value.properties, "apiServerAccessProfile")
	common_lib.valid_key(value.properties.apiServerAccessProfile, "authorizedIPRanges")
	issue := {
		"resourceType": value.type,
		"resourceName": value.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'apiServerAccessProfile.authorizedIPRanges' is empty",
		"sk": ".properties.apiServerAccessProfile.authorizedIPRanges",
		"sl": ["properties", "apiServerAuthorizedIPRanges", "authorizedIPRanges"],
	}
} else = issue {
	issue := {
		"resourceType": value.type,
		"resourceName": value.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'apiServerAccessProfile.authorizedIPRanges' is undefined",
		"sk": "",
		"sl": ["name"],
	}
}
