package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "dns.v1.managedZone"

	resource.properties.dnssecConfig.defaultKeySpecs[idx].algorithm == "rsasha1"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.dnssecConfig.defaultKeySpecs.algorithm", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'algorithm' is not equal to 'rsasha1'",
		"keyActualValue": "'algorithm' is equal to 'rsasha1'",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "dnssecConfig", "defaultKeySpecs", idx, "algorithm"], []),
	}
}
