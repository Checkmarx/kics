package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  kms_key := playbooks[j]
  instance := kms_key["google.cloud.gcp_kms_crypto_key"]

  rotation_period := substring(instance.rotation_period,0,count(instance.rotation_period)-1)
  seconds_in_a_year := 315356000
  to_number(rotation_period) > seconds_in_a_year

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period", [playbooks[j].name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is at most '315356000s'", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is '%ss'", [playbooks[j].name,rotation_period])
              }
}

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  kms_key := playbooks[j]
  instance := kms_key["google.cloud.gcp_kms_crypto_key"]

  object.get(instance,"rotation_period","undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}", [playbooks[j].name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue":  sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is set", [playbooks[j].name]),
                "keyActualValue": 	sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is undefined", [playbooks[j].name])
              }
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}