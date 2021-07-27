package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not is_last_tls(value)

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'siteConfig.minTlsVersion' is 1.2",
		"keyActualValue": issue.keyActualValue,
	}
}

is_last_tls(resource) {
	resource.properties.siteConfig.minTlsVersion == "1.2"
}

prepare_issue(resource) = issue {
	_ = resource.properties.siteConfig.minTlsVersion
	not is_null(resource.properties.siteConfig.minTlsVersion)
	resource.properties.siteConfig.minTlsVersion != "1.2"
	issue := {
		"issueType": "IncorrectValue",
		"keyActualValue": "'minTlsVersion' is not 1.2",
		"sk": ".properties.siteConfig.minTlsVersion",
	}
} else = issue {
	issue := {
		"issueType": "MissingAttribute",
		"keyActualValue": "'siteConfig.minTlsVersion' is undefined",
		"sk": "",
	}
}
