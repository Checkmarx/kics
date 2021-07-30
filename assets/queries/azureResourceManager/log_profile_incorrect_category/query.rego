package Cx

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"

	category := value.properties.categories[x]
	all([category != "Write", category != "Delete", category != "Action"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{microsoft.insights/logprofiles}}.properties.categories",
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'microsoft.insights/logprofiles' has categories[%d] set to 'Write', 'Delete' or 'Action'", [x]),
		"keyActualValue": sprintf("resource with type 'microsoft.insights/logprofiles' has categories[%d] set to '%s'", [x, category]),
	}
}
