package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
    openapi_lib.check_openapi(doc) == "3.0"

    [path, value] := walk(doc)
    content = value.content[mime]

    # Ensure "content" inside "properties" is treated as a field name, not an OpenAPI content spec.
    not path[count(path) - 1] == "properties"
    not openapi_lib.is_valid_mime(mime)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("%s.content.%s", [openapi_lib.concat_path(path), mime]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "The Media Type should be a valid value",
        "keyActualValue": "The Media Type is an invalid value",
    }
}
