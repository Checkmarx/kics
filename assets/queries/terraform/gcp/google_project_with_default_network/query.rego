package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.google_project[name]
    not resource.auto_create_network == false

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("google_project[%s].auto_create_network", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'auto_create_network' is equal 'false'",
                "keyActualValue": 	"'auto_create_network' is equal 'true'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}