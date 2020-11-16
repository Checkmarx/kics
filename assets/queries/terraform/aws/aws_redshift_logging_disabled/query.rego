package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_redshift_cluster[name]
  resource.logging.enable == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_redshift_cluster[%s].logging", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_redshift_cluster.logging' is true",
                "keyActualValue": 	"'aws_redshift_cluster.logging' is false",
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_redshift_cluster[name]
  object.get(resource, "logging", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_redshift_cluster[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'aws_redshift_cluster.logging' is true",
                "keyActualValue": 	"'aws_redshift_cluster.logging' is undefined",
              }
}