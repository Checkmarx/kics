package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  redis_cache := playbooks[j]
  instance := redis_cache["azure_rm_rediscache"]
  
  isTrue(instance.enable_non_ssl_port)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{azure_rm_rediscache}}.enable_non_ssl_port", [playbooks[j].name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{azure_rm_rediscache}}.enable_non_ssl_port is false or undefined", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{azure_rm_rediscache}}.enable_non_ssl_port is true", [playbooks[j].name])
              }
}

isTrue(attribute) {
  attribute == "yes"
} else {
  attribute == true
} else = false

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}