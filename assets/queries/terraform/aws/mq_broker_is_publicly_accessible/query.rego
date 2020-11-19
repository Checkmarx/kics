package Cx

CxPolicy [ result ] {
  broker := input.document[i].resource.aws_mq_broker[name]
  broker.publicly_accessible == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_mq_broker[%s].publicly_accessible", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'publicly_accessible' is undefined or set to false",
                "keyActualValue": 	"'publicly_accessible' is set to true"
              }
}