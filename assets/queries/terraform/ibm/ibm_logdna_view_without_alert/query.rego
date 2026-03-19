package Cx

# REGLA: Detectar vistas de LogDNA que no tienen ninguna alerta asociada.
CxPolicy[result] {
    doc := input.document[i]
    view := doc.resource.ibm_logdna_view[view_name]

    matching_alerts := [alert |
        alert := input.document[_].resource.ibm_logdna_alert[_]
        contains(alert.view, view_name)
    ]

    count(matching_alerts) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_logdna_view.%s", [view_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "ibm_logdna_view should have an associated ibm_logdna_alert",
        "keyActualValue": "ibm_logdna_view does not have an associated ibm_logdna_alert",
    }
}