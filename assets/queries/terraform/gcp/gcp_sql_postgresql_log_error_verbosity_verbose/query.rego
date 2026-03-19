package Cx

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { is_object(x) }

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_sql_database_instance[name]

    contains(resource.database_version, "POSTGRES")

    flags := ensure_array(resource.settings.database_flags)
    flag := flags[j]
    
    flag.name == "log_error_verbosity"
    lower(flag.value) == "verbose"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_sql_database_instance.%s.settings.database_flags", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'log_error_verbosity' should be set to 'default' or 'terse'",
        "keyActualValue": sprintf("'log_error_verbosity' is set to '%s'", [flag.value]),
    }
}