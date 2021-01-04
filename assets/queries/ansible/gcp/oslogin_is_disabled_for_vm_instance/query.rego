package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  compute_instance := playbooks[j]
  instance := compute_instance["google.cloud.gcp_compute_instance"]
  metadata := instance.metadata
  
  object.get(metadata,"enable-oslogin","undefined") != "undefined"

  not isTrue(object.get(metadata,"enable-oslogin","undefined"))

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin", [playbooks[j].name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin' is true", [playbooks[j].name]),
                "keyActualValue": 	sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.enable-oslogin' is false", [playbooks[j].name])
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