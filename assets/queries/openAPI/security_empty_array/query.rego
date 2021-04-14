package Cx

import data.generic.openapi as openAPILib

CxPolicy [ result ] {
  doc := input.document[i]
  openAPILib.checkOpenAPI(doc) != "undefined"
  object.get(doc, "security", "undefined") == "undefined"

	result := {
                "documentId": 		doc.id,
                "searchKey": 	    "openapi",
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "A default security schema should be defined",
                "keyActualValue": 	"A default security schema is not defined"
              }
}

CxPolicy [ result ] {
  doc := input.document[i]
  openAPILib.checkOpenAPI(doc) != "undefined"
  object.get(doc, "security", "undefined") != "undefined"

  count(doc.security) == 0

	result := {
                "documentId": 		doc.id,
                "searchKey": 	    "security",
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "A default security schema should be defined",
                "keyActualValue": 	"A default security schema is not defined"
              }
}
