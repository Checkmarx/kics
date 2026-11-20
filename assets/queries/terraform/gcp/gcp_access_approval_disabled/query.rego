package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# CASE 1: Project without Access Approval configuration.
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
        "resourceType": "google_project",
        "resourceName": tf_lib.get_resource_name(project, name),
        "searchKey": sprintf("google_project[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_project", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'google_project.%s' should have 'google_access_approval_project_settings' associated", [name]),
        "keyActualValue": sprintf("'google_project.%s' does not have Access Approval configured", [name]),
    }
}

# CASE 2: Access Approval configured but without enrolled services.
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.google_access_approval_project_settings[name]

    not settings.enrolled_services

    result := {
        "documentId": doc.id,
        "resourceType": "google_access_approval_project_settings",
        "resourceName": tf_lib.get_resource_name(settings, name),
        "searchKey": sprintf("google_access_approval_project_settings[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_access_approval_project_settings", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Must have at least one 'enrolled_services' block defined",
        "keyActualValue": "'enrolled_services' is missing",
    }
}
