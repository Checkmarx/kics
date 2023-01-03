package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)
	value.type == "Microsoft.ContainerService/managedClusters"
	value.apiVersion != "2017-08-03"
	not dashboard_is_disabled(doc, value)

	issue := prepare_issue(doc, value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'addonProfiles.kubeDashboard.enabled' should be defined and false",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

dashboard_is_disabled(doc, resource) {
	common_lib.valid_key(resource, "properties")
	common_lib.valid_key(resource.properties, "addonProfiles")
	common_lib.valid_key(resource.properties.addonProfiles, "kubeDashboard")
	common_lib.valid_key(resource.properties.addonProfiles.kubeDashboard, "enabled")
	[enabled_value, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, resource.properties.addonProfiles.kubeDashboard.enabled)
	enabled_value == false
}

prepare_issue(doc, resource) = issue {
	[_, type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, resource.properties.addonProfiles.kubeDashboard.enabled)
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'addonProfiles.kubeDashboard.enabled' %s is false", [type]),
		"sk": ".properties.addonProfiles.kubeDashboard.enabled",
		"sl": ["properties", "addonProfiles", "kubeDashboard", "enabled"],
	}
}
