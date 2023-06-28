package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	types := {"allOf", "oneOf", "anyOf", "not"}
	common_lib.valid_key(value[types[prop]][n], "RefMetadata")
	properties := value[types[prop]][n]
	refPaths := {
		"2.0": "#/definitions/",
		"3.0": "#/components/schemas/",
	}

	trim_prefix(properties["RefMetadata"]["$ref"], refPaths[version]) == path[minus(count(path), 1)]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s.$ref=%s", [openapi_lib.concat_path(path), types[prop], properties["RefMetadata"]["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s should not reference own schema", [concat(".", path), types[prop]]),
		"keyActualValue": sprintf("%s.%s reference own schema", [concat(".", path), types[prop]]),
		"overrideKey": version,
	}
}
