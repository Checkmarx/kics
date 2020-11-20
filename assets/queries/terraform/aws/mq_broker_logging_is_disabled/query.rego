package Cx

CxPolicy [ result ] {
  broker := input.document[i].resource.aws_mq_broker[name]
  logs := broker.logs

  categories := ["general","audit"]

  some j
    type := categories[j]
    logs[type] == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_mq_broker[%s].logs.%s", [name,type]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'general' and 'audit' logging are set to true",
                "keyActualValue": 	sprintf("'%s' is set to false",[type])
              }
}

CxPolicy [ result ] {
  broker := input.document[i].resource.aws_mq_broker[name]
  logs := broker.logs

  categories := ["general","audit"]

  some j
    type := categories[j]
    not has_key(logs,type)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_mq_broker[%s].logs", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'general' and 'audit' logging are set to true",
                "keyActualValue": 	"'general' and/or 'audit' is undefined"
              }
}

CxPolicy [ result ] {
  broker := input.document[i].resource.aws_mq_broker[name]
 
  not broker.logs

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_mq_broker[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'logs' is set and enabling general AND audit logging",
                "keyActualValue": 	"'logs' is undefined"
              }
}

has_key(obj,key) {
  _ = obj[key]
}