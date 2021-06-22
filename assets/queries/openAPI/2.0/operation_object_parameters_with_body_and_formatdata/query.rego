package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	count(path) > 0
	param := value.parameters
	body := [x | p := param[_]; p.in == "body"; x := p.in]
	formatData := [x | p := param[_]; p.in == "formatData"; x := p.in]
	count(body) > 0
	count(formatData) > 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.parameters", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "operation object parameters only use one of 'body' or 'formatData' locations",
		"keyActualValue": "operation object parameters use both 'body' and 'formatData' locations",
	}
}
