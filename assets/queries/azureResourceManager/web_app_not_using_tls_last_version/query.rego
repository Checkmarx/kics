package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
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
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'siteConfig.minTlsVersion' is undefined",
		"keyExpectedValue": "'siteConfig.minTlsVersion' should be defined",
		"sk": ".properties",
		"sl": ["name"],
	}
}
