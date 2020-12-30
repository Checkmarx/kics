package Cx

CxPolicy [ result ] {
  document = input.document[i]
  tasks := getTasks(document)
  elasticsearch = tasks[_][j]
  elasticsearchBody = elasticsearch["ec2_elasticsearch"]
  elasticsearchName = elasticsearchBody.name
  is_disabled(elasticsearchBody.encryption_at_rest_enabled)
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.{{encryption_at_rest_enabled}}", [elasticsearchName]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name={{%s}}.encryption_at_rest_enabled should be enabled", [elasticsearchName]),
                "keyActualValue": 	sprintf("name={{%s}}.encryption_at_rest_enabled is disabled", [elasticsearchName])
              }
}
CxPolicy [ result ] {
  document = input.document[i]
  tasks := getTasks(document)
  elasticsearch = tasks[_][j]
  elasticsearchBody = elasticsearch["ec2_elasticsearch"]
  elasticsearchName = elasticsearchBody.name
  object.get(elasticsearchBody,"encryption_at_rest_enabled","undefined")== "undefined"
  
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}", [elasticsearchName]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("name={{%s}}.encryption_at_rest_enabled should be set and enabled", [elasticsearchName]),
                "keyActualValue": 	sprintf("name={{%s}}.encryption_at_rest_enabled is undefined", [elasticsearchName])
              }
}


is_disabled(value) = true {
      negativeValue = { "False",false,"false","No","no"}
   	  value==negativeValue[_]
} else = false {
     true

}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
