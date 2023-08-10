package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib


CxPolicy[result] {
	defaults := input.document[i].groups.defaults

    not common_lib.valid_key(defaults, "plugin_filters_cfg")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "defaults",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "plugin_filters_cfg should be defined and set to a path to configuration",
		"keyActualValue": "plugin_filters_cfg is not defined",
	}
}