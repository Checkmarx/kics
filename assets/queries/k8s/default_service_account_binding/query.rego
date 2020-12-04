package Cx

CxPolicy [ result ] {
	document := input.document[i]
    subjects := document.subjects
    subjects[c].kind == "ServiceAccount"
    subjects[c].name == "default"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	   sprintf("subjects.name=%s", [subjects[c].name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("subjects.name=%s is not default", [subjects[c].name]),
                "keyActualValue": 	sprintf("subjects.name=%s is default", [subjects[c].name])
              }
}

