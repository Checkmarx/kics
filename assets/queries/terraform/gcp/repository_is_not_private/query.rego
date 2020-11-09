package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.github_repository[name]
    not resource.private = true
    not resource.visibility = "private"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("github_repository[%s].private", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'private' is equal 'true'",
                "keyActualValue": 	"'private' is equal 'false'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}