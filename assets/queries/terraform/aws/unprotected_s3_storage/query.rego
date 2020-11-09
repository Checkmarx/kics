package Cx

CxPolicy [ result ] {
	resource := input.file[i].resource.aws_s3_bucket[name]
	not resource.server_side_encryption_configuration

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].server_side_encryption_configuration", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'server_side_encryption_configuration' exists",
                "keyActualValue": 	"'server_side_encryption_configuration' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.bucket
              }
}