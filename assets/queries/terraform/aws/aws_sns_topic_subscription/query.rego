package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_sns_topic[name]
  jsonPolicy := json.unmarshal(resource.policy)
  policyStat := jsonPolicy.Statement[_]
  policyStat.Effect == "Allow"
  policyStat.Principal.AWS == "*"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [policyStat.Principal.AWS]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'Statement.Principal.AWS' doesn't contain '*'",
                "keyActualValue": 	"'Statement.Principal' contains '*'"
              }
}