package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"

	category := value.properties.categories[x]
	all([category != "Write", category != "Delete", category != "Action"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.categories", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'microsoft.insights/logprofiles' has categories[%d] set to 'Write', 'Delete' or 'Action'", [x]),
		"keyActualValue": sprintf("resource with type 'microsoft.insights/logprofiles' has categories[%d] set to '%s'", [x, category]),
		"searchLine": common_lib.build_search_line(path, ["properties", "categories", x]),
	}
}
