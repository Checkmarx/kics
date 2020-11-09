package Cx

#default of block_public_policy is false
CxPolicy [ result ] {
    bucket := input.file[i].resource.aws_s3_bucket[name]
	not bucket.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'server_side_encryption_configuration.rule.apply_server_side_encryption_by_default' exists",
                "keyActualValue": 	"'server_side_encryption_configuration.rule.apply_server_side_encryption_by_default' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
