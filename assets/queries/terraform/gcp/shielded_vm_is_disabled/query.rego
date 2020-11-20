package Cx

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data, "shielded_instance_config", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s]", [appserver]),
                "issueType":        "MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config' is defined",
                "keyActualValue":   "Attribute 'shielded_instance_config' is undefined"
              }
}
CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":        "MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is defined",
                "keyActualValue":   "Attribute 'shielded_instance_config.enable_secure_boot' is undefined"
              }
}
CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":        "MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_vtpm' is defined",
                "keyActualValue":   "Attribute 'shielded_instance_config.enable_vtpm' is undefined"
              }
}
CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  object.get(data.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s].shielded_instance_config", [appserver]),
                "issueType":        "MissingAttribute", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is defined",
                "keyActualValue":   "Attribute 'shielded_instance_config.enable_integrity_monitoring' is undefined"
              }
}
CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_integrity_monitoring == false
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s].shielded_instance_config.enable_integrity_monitoring", [appserver]),
                "issueType":        "IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_integrity_monitoring' is true",
                "keyActualValue":   "Attribute 'shielded_instance_config.enable_integrity_monitoring' is false"
              }
}
CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_vtpm == false
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s].shielded_instance_config.enable_vtpm", [appserver]),
                "issueType":        "IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_vtpm' is true",
                "keyActualValue":   "Attribute 'shielded_instance_config.enable_vtpm' is false"
              }
}
CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.shielded_instance_config.enable_secure_boot == false
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_compute_instance[%s].shielded_instance_config.enable_secure_boot", [appserver]),
                "issueType":        "IncorrectValue", 
                "keyExpectedValue": "Attribute 'shielded_instance_config.enable_secure_boot' is true",
                "keyActualValue":   "Attribute 'shielded_instance_config.enable_secure_boot' is false"
              }
}