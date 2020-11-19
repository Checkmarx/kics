package Cx

CxPolicy [ result ] {
  
  settings := input.document[i].resource.google_sql_database_instance[name].settings
  object.get(settings, "backup_configuration", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_sql_database_instance[%s].settings", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "settings.backup_configuration is defined",
                "keyActualValue":   "settings.backup_configuration is undefined"
              }
}

CxPolicy [ result ] {
  
  settings := input.document[i].resource.google_sql_database_instance[name].settings.backup_configuration
  object.get(settings, "enabled", "undefined") == "undefined"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_sql_database_instance[%s].settings.backup_configuration", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "settings.backup_configuration.enabled is defined",
                "keyActualValue":   "settings.backup_configuration.enabled is undefined"
              }
}

CxPolicy [ result ] {
  
  settings := input.document[i].resource.google_sql_database_instance[name].settings
  settings.backup_configuration.enabled == false
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("google_sql_database_instance[%s].settings.backup_configuration.enabled", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "settings.backup_configuration.enabled is true",
                "keyActualValue":   "settings.backup_configuration.enabled is false"
              }
}

