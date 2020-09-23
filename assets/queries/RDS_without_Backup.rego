package Cx

SupportedResources = "$.resource.aws_db_instance"

CxPolicy [ result ] {
    db := input.document[i].resource.aws_db_instance[name]
    db.backup_retention_period == 0

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_db_instance[%s].backup_retention_period", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT 0",
                "keyActualValue": 	0
              })
}
