package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_sqs_queue[name]
    object.get(resource, "kms_master_key_id", "not found") == "not found"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'kms_master_key_id' exists",
                "keyActualValue": 	"'kms_master_key_id' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.name
              }
}
