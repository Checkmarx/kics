package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	parameters := value.parameters

	paramOne := parameters[keyOne]
	paramTwo := parameters[keyTwo]
	keyOne != keyTwo
	paramOne.name == paramTwo.name
	paramOne.in == paramTwo.in

	partialSk := openapi_lib.concat_default_value(openapi_lib.concat_path(path), "parameters")
	sk := openapi_lib.get_complete_search_key(keyOne, partialSk, "name")

	result := {
		"documentId": doc.id,
		"searchKey": sk,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter has unique 'name' and 'in' combinations",
		"keyActualValue": "Parameter does not have unique 'name' and 'in' combinations",
		"overrideKey": version,
	}
}
