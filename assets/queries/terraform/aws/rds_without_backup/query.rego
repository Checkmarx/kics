package Cx

CxPolicy [ result ] {
    db := input.file[i].resource.aws_db_instance[name]
    not db.backup_retention_period

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_db_instance[%s].backup_retention_period", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'backup_retention_period' exists",
                "keyActualValue": 	"'backup_retention_period' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            db.name
              }
}

CxPolicy [ result ] {
    db := input.file[i].resource.aws_db_instance[name]
    db.backup_retention_period == 0

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_db_instance[%s].backup_retention_period", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'backup_retention_period' is not equal '0'",
                "keyActualValue": 	"'backup_retention_period' is equal '0'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            db.name
              }
}
