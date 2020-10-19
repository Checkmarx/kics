package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	not resource.server_side_encryption_configuration

    result := {
                "test": resource,
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].server_side_encryption_configuration", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'server_side_encryption_configuration' exists",
                "keyActualValue": 	"'server_side_encryption_configuration' is missing",
                "value":            resource.bucket
              }
}