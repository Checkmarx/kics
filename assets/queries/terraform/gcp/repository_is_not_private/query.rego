package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.github_repository[name]
    not resource.private = true
    not resource.visibility = "private"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("github_repository[%s].private", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'private' is equal 'true'",
                "keyActualValue": 	"'private' is equal 'false'"
              }
}