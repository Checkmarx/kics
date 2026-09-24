package Cx

import data.generic.common as common_lib

# REGLA: Detectar vistas de LogDNA que no tienen NO alerta asociada.
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
        "searchLine": common_lib.build_search_line(["resource", "ibm_logdna_view", view_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "ibm_logdna_view should have an associated ibm_logdna_alert",
        "keyActualValue": "ibm_logdna_view does not have an associated ibm_logdna_alert",
    }
}