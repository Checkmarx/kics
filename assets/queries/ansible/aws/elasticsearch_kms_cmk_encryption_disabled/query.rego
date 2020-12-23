package Cx

CxPolicy [ result ] {
  document = input.document[i]
  tasks := getTasks(document)
  elasticsearch = tasks[_][j]
  elasticsearchBody = elasticsearch["ec2_elasticsearch"]
  elasticsearchName = elasticsearchBody.name
  not is_disabled(elasticsearchBody.encryption_at_rest_enabled)
    object.get(elasticsearchBody, "encryption_at_rest_kms_key_id" , "undefined") == "undefined"
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.{{encryption_at_rest_kms_key_id}}", [elasticsearchName]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("name={{%s}}.encryption_at_rest_kms_key_id should be defined", [elasticsearchName]),
                "keyActualValue": 	sprintf("name={{%s}}.encryption_at_rest_kms_key_id is undefined", [elasticsearchName])
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