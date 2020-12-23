package Cx

CxPolicy [result] {
  document = input.document[i]
  tasks := getTasks(document)
  rds_instance := tasks[_]
  rds_instanceBody := rds_instance["community.aws.rds_instance"]
  rds_instanceName := rds_instance.name 
  is_disabled(rds_instanceBody.enable_iam_database_authentication)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.enable_iam_database_authentication", [rds_instanceName]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("{{%s}}.enable_iam_database_authentication should be enabled.", [rds_instanceName]),
                "keyActualValue": 	sprintf("{{%s}}.enable_iam_database_authentication is disabled", [rds_instanceName])
              }
}


CxPolicy [result] {
  document = input.document[i]
  tasks := getTasks(document)
  rds_instance := tasks[_]
  rds_instanceBody := rds_instance["community.aws.rds_instance"]
  rds_instanceName := rds_instance.name 
  object.get(rds_instanceBody,"enable_iam_database_authentication","undefined") == "undefined"
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.enable_iam_database_authentication", [rds_instanceName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("{{%s}}.enable_iam_database_authentication should be defined", [rds_instanceName]),
                "keyActualValue": 	sprintf("{{%s}}.enable_iam_database_authentication is undefined", [rds_instanceName])
              }
}

is_disabled(value) = true {
      negativeValue = { "False",false,"false","No","no"}
   	  value == negativeValue[_]
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