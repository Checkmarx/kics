package Cx

CxPolicy [ result ] {
  compute := input.document[i].resource.google_compute_instance[name]
  metadata := compute.metadata
  oslogin := object.get(metadata,"enable-oslogin","undefined")
  isFalse(oslogin)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].metadata.enable-oslogin", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("google_compute_instance[%s].metadata.enable-oslogin is true or undefined", [name]),
                "keyActualValue": sprintf("google_compute_instance[%s].metadata.enable-oslogin is false", [name])
              }
}

isFalse(value) = true {
  is_string(value)
  lower(value) == "false"
}

isFalse(value) = true {
  is_boolean(value)
  not value
}