package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	responses := doc.paths[n][oper].responses

	count({x |
	    response := responses[x]
	    oper != "head"
	    regex.match(`^20[0124]$`, x) == true
    }) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses has at least one successful HTTP status code defined", [n, oper]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses does not have at least one successful HTTP status code defined", [n, oper]),
		"overrideKey": version,
		"searchLine": common_lib.build_search_line(["paths", n, oper, "responses"], []),
	}
}
