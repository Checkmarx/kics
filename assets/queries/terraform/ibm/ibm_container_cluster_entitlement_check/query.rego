package Cx

import data.generic.common as common_lib

# REGLA: Verificar si el cluster tiene configurada la clave de "entitlement".
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.ibm_container_cluster[name]

    object.get(cluster, "entitlement", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_container_cluster.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_container_cluster", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'entitlement' attribute should be defined for clusters running IBM Entitled Software",
        "keyActualValue": "'entitlement' attribute is missing",
    }
}