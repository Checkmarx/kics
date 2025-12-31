package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] { # resource of type Microsoft.Web/sites without child resources of type Microsoft.Web/sites/config
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	
	children_array := arm_lib.get_children(doc, value, path)
	
	#check_tls_version(doc, value, path, children_array)
	count(children_array) == 0
	not is_last_tls(doc, value)

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": issue.keyExpectedValue,
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	
	children_array := arm_lib.get_children(doc, value, path)
	not count(children_array) == 0
	child_resource := children_array[_]
	is_sites_config(child_resource.value.type)
	child_resource_status := get_child_resource_info(doc, child_resource.value)
	
	res := check_tls_version(doc, value, path, child_resource, child_resource_status)

	result := {
		"documentId": input.document[i].id,
		"resourceType": res["rt"],
		"resourceName": res["rn"],
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

check_tls_version(doc, value, path, child_resource, child_resource_status) = res {
	# child resource without minTlsVersion defined but parent resource with the field incorrectly defined 
	child_resource_status == "not defined"
	not is_last_tls(doc, value)

	issue := prepare_issue(value)
	issue.issueType == "IncorrectValue"
	res := {
		"rt": value.type,
		"rn": value.name,
		"sk": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"it": issue.issueType,
		"kev": issue.keyExpectedValue,
		"kav": issue.keyActualValue,
		"sl": common_lib.build_search_line(path, issue.sl),
	}
} else = res {
	# both child and parent resources with minTlsVersion field not defined
	child_resource_status == "not defined"
	not is_last_tls(doc, value)

	issue := prepare_issue(value)
	issue.issueType == "MissingAttribute"
	res := {
		"rt": child_resource.value.type,
		"rn": child_resource.value.name,
		"sk": sprintf("%s.name=%s.properties", [common_lib.concat_path(child_resource.path), child_resource.value.name]),
		"it": "MissingAttribute",
		"kev": "'minTlsVersion' should be defined with the version '1.2' or higher",
		"kav": "'minTlsVersion' is not defined",
		"sl": common_lib.build_search_line(child_resource.path, ["properties"]),
	}
} else = res {
	# child resource with minTlsVersion incorrectly defined
	child_resource_status == "not correctly defined"
	res := {
		"rt": child_resource.value.type,
		"rn": child_resource.value.name,
		"sk": sprintf("%s.name=%s.properties.minTlsVersion", [common_lib.concat_path(child_resource.path), child_resource.value.name]),
		"it": "IncorrectValue",
		"kev": "'minTlsVersion' should be defined with the version '1.2' or higher",
		"kav": sprintf("'minTlsVersion' is defined to '%s'", [child_resource.value.properties.minTlsVersion]),
		"sl": common_lib.build_search_line(child_resource.path, ["properties", "minTlsVersion"])
	}
}

get_child_resource_info(doc, child_resource) = info {
	not common_lib.valid_key(child_resource.properties, "minTlsVersion")
	info := "not defined"
} else = info {
	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, child_resource.properties.minTlsVersion)
	val != "1.3"
	val != "1.2"
	info := "not correctly defined"
} else = null

is_last_tls(doc, resource) {
	[val, _] :=  arm_lib.getDefaultValueFromParametersIfPresent(doc, resource.properties.siteConfig.minTlsVersion)
	val == "1.3"
}

is_last_tls(doc, resource) {
	[val, _] :=  arm_lib.getDefaultValueFromParametersIfPresent(doc, resource.properties.siteConfig.minTlsVersion)
	val == "1.2"
}

prepare_issue(resource) = issue {
	common_lib.valid_key(resource, "properties")
	common_lib.valid_key(resource.properties, "siteConfig")
	common_lib.valid_key(resource.properties.siteConfig, "minTlsVersion")
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'minTlsVersion' is not 1.2 or 1.3",
		"keyExpectedValue": "'siteConfig.minTlsVersion' should be 1.2 or 1.3",
		"sk": ".properties.siteConfig.minTlsVersion",
		"sl": ["properties", "siteConfig", "minTlsVersion"],
	}
} else = issue {
	common_lib.valid_key(resource, "properties")
	common_lib.valid_key(resource.properties, "siteConfig")
	not common_lib.valid_key(resource.properties.siteConfig, "minTlsVersion")

	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'minTlsVersion' is undefined",
		"keyExpectedValue": "'minTlsVersion' should be defined",
		"sk": ".properties.siteConfig",
		"sl": ["properties", "siteConfig"],
	}
} else = issue {
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'siteConfig.minTlsVersion' is undefined",
		"keyExpectedValue": "'siteConfig.minTlsVersion' should be defined",
		"sk": ".properties",
		"sl": ["properties"],
	}
}

is_sites_config(resource_type) {
	resource_type == "Microsoft.Web/sites/config"
} else {
	resource_type == "config"
} else = false