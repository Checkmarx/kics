package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_lambda_function[name]
    vars = resource.environment.variables
    re_match("[A-Za-z0-9/+=]{40}", vars[var])

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_lambda_function[%s].environment.variables", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'environment.variables' doesn't contain access key",
                "keyActualValue": 	"'environment.variables' contains access key",
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
    resource := input.file[i].resource.aws_lambda_function[name]
    vars = resource.environment.variables
    re_match("[A-Z0-9]{20}", vars[var])

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_lambda_function[%s].environment.variables", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'environment.variables' doesn't contain access key",
                "keyActualValue": 	"'environment.variables' contains access key",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
