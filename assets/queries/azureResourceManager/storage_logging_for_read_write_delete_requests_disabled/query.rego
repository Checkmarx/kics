package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cats := ["StorageRead", "StorageWrite", "StorageDelete"]

	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticsettings"

	valSlice := [x | x := {sprintf("%s", [value.properties.logs[n].category]): value.properties.logs[n].enabled}]

	unionObject := {k: v |
		some i, k
		v := valSlice[i][k]
	}

	issue := actual_issue(unionObject, cats[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.logs.%s", [common_lib.concat_path(path), value.name, cats[l]]),
		"issueType": issue.type,
		"keyExpectedValue": sprintf("'diagnosticsettings.properties.logs.%s' should be defined and enabled", [cats[l]]),
		"keyActualValue": sprintf("'diagnosticsettings.properties.logs.%s' is %s", [issue.msg]),
		"searchLine": common_lib.build_search_line(path, ["properties", "logs", cats[l]]),
	}
}

actual_issue(obj, key) = issue {
	not common_lib.valid_key(obj, key)
	issue := {"msg": "missing", "type": "MissingAttribute"}
} else = issue {
	obj[key] == false
	issue := {"msg": "false", "type": "IncorrectValue"}
}
