package Cx

# CASO 1: Proyecto sin configuración de Access Approval.
CxPolicy[result] {
    doc := input.document[i]
    project := doc.resource.google_project[name]
    
    settings := [s |
        s := doc.resource.google_access_approval_project_settings[_]
        contains(s.project_id, name)
    ]

    count(settings) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_project.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'google_project.%s' should have 'google_access_approval_project_settings' associated", [name]),
        "keyActualValue": sprintf("'google_project.%s' does not have Access Approval configured", [name]),
    }
}

# CASO 2: Access Approval configurado pero sin servicios inscritos.
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.google_access_approval_project_settings[name]

    not settings.enrolled_services

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_access_approval_project_settings.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Must have at least one 'enrolled_services' block defined",
        "keyActualValue": "'enrolled_services' is missing",
    }
}