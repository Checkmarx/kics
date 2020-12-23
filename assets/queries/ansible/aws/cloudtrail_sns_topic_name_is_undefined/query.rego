package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  redis_cache := playbooks[j]
  instance := redis_cache["community.aws.cloudtrail"]
  
  not instance.sns_topic_name

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{community.aws.cloudtrail}}", [playbooks[j].name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is set", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is undefined", [playbooks[j].name])
              }
}

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  redis_cache := playbooks[j]
  instance := redis_cache["community.aws.cloudtrail"]
  
  instance.sns_topic_name == null

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name", [playbooks[j].name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is set", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is empty", [playbooks[j].name])
              }
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}