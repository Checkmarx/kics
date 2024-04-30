package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cats := ["StorageRead", "StorageWrite", "StorageDelete"]

	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticsettings"

	
	valSlice:= [x | x := {
    	sprintf("%s", [value.properties.logs[n].category]): [value.properties.logs[n].enabled, n]
        }]

	unionObject := {k: v |
		some i, k
    	v := valSlice[i][k][0]
      }

	catIndexObject := {k: v |
		some i, k
    	v := valSlice[i][k][1]
      }

	issue := actual_issue(unionObject, catIndexObject, cats[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.logs.%s", [common_lib.concat_path(path), value.name, cats[l]]),
		"issueType": issue.type,
		"keyExpectedValue": issue.expected_value,
		"keyActualValue": issue.actual_value,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

actual_issue(obj, catIndexObject, key) = issue {
	not common_lib.valid_key(obj, key)
	issue := {
    	"expected_value": sprintf("'Storage Logging' in 'diagnosticsettings' needs '%s' method", [key]),
        "actual_value": sprintf("'Storage Logging' in 'diagnosticsettings' doesn't have a '%s' method", [key]),
        "type": "MissingAttribute",
        "sl": ["properties", "logs"]
      }
} else = issue {
	obj[key] == false
	issue := {
    	"expected_value": sprintf("Storage Logging in 'diagnosticsettings' should be enabled for '%s' method", [replace(key, "Storage", "")]),
    	"actual_value": sprintf("Storage Logging in 'diagnosticsettings' is disabled for '%s' method", [replace(key, "Storage", "")]),
    	"type": "IncorrectValue",
        "sl": ["properties", "logs", catIndexObject[key], "enabled"]
    }
}