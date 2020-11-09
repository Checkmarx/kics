package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.google_bigquery_dataset[name]
    access := resource.access
    is_object(access)
	access.special_group == "allAuthenticatedUsers"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("google_bigquery_dataset[%s].access.special_group", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'access.special_group' is not equal 'allAuthenticatedUsers'",
                "keyActualValue": 	"'access.special_group' is equal 'allAuthenticatedUsers'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.google_bigquery_dataset[name]
    access := resource.access
    is_array(access)
	access[_].special_group == "allAuthenticatedUsers"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("google_bigquery_dataset[%s].access.special_group", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'access.special_group' is not equal 'allAuthenticatedUsers'",
                "keyActualValue": 	"'access.special_group' is equal 'allAuthenticatedUsers'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}