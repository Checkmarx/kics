package Cx

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data, "shielded_instance_config", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s]", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") != "undefined"
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") != "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_secure_boot' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") != "undefined"
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") != "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_vtpm' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_vtpm' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") != "undefined"
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") != "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_integrity_monitoring' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") != "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is defined and Attribute 'shielded_instance_config.enable_vtpm' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_integrity_monitoring' is undefined and Attribute 'shielded_instance_config.enable_vtpm' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") != "undefined"
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is defined and Attribute 'shielded_instance_config.enable_secure_boot' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_integrity_monitoring' is undefined and Attribute 'shielded_instance_config.enable_secure_boot' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") != "undefined"
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_vtpm' is defined and Attribute 'shielded_instance_config.enable_secure_boot' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_vtpm' is undefined and Attribute 'shielded_instance_config.enable_secure_boot' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is defined, Attribute 'shielded_instance_config.enable_vtpm' is defined and Attribute 'shielded_instance_config.enable_secure_boot' is defined",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_integrity_monitoring' is undefined, Attribute 'shielded_instance_config.enable_vtpm' is undefined and Attribute 'shielded_instance_config.enable_secure_boot' is undefined"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_integrity_monitoring == false
  data.shielded_instance_config.enable_vtpm
  data.shielded_instance_config.enable_secure_boot

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_integrity_monitoring' is false"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_vtpm == false
  data.shielded_instance_config.enable_integrity_monitoring 
  data.shielded_instance_config.enable_secure_boot

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_vtpm' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_vtpm' is false"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_secure_boot == false
  data.shielded_instance_config.enable_vtpm
  data.shielded_instance_config.enable_integrity_monitoring 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_secure_boot' is false"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_secure_boot == false
  data.shielded_instance_config.enable_vtpm == false
  data.shielded_instance_config.enable_integrity_monitoring 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is true and Attribute 'shielded_instance_config.enable_secure_vtpm' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_secure_boot' is false and Attribute 'shielded_instance_config.enable_secure_vtpm' is false"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_secure_boot == false
  data.shielded_instance_config.enable_vtpm 
  data.shielded_instance_config.enable_integrity_monitoring == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is true and Attribute 'shielded_instance_config.enable_integrity_monitoring' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_secure_boot' is false and Attribute 'shielded_instance_config.enable_integrity_monitoring' is false"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_secure_boot 
  data.shielded_instance_config.enable_vtpm == false
  data.shielded_instance_config.enable_integrity_monitoring == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_vtpm' is true and Attribute 'shielded_instance_config.enable_integrity_monitoring' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_vtpm' is false and Attribute 'shielded_instance_config.enable_integrity_monitoring' is false"
              }
}

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_secure_boot == false
  data.shielded_instance_config.enable_vtpm == false
  data.shielded_instance_config.enable_integrity_monitoring == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is true, Attribute 'shielded_instance_config.enable_secure_vtpm' is true and Attribute 'shielded_instance_config.enable_integrity_monitoring' is true",
                "keyActualValue": 	"Attribute 'shielded_instance_config.enable_secure_boot' is false, Attribute 'shielded_instance_config.enable_secure_vtpm' is false and Attribute 'shielded_instance_config.enable_integrity_monitoring' is false"
              }
}