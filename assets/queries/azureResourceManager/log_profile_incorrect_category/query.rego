package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"

	[category, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.categories[x])
	all([category != "Write", category != "Delete", category != "Action"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.categories", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'microsoft.insights/logprofiles' should have categories[%d] %s set to 'Write', 'Delete' or 'Action'", [val_type, x]),
		"keyActualValue": sprintf("resource with type 'microsoft.insights/logprofiles' has categories[%d] set to '%s'", [x, category]),
		"searchLine": common_lib.build_search_line(path, ["properties", "categories", x]),
	}
}
