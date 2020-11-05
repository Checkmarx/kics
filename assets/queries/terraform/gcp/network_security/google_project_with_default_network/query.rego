package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.google_project[name]
    not resource.auto_create_network == false

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_project[%s].auto_create_network", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'auto_create_network' is equal 'false'",
                "keyActualValue": 	"'auto_create_network' is equal 'true'"
              }
}