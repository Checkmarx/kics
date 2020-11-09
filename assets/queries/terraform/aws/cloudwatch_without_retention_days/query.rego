package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_cloudwatch_log_group[name]
    not resource.retention_in_days

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_cloudwatch_log_group[%s].retention_in_days", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'retention_in_days' equal 30",
                "keyActualValue": 	"'retention_in_days' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}


