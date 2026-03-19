package Cx

# REGLA: Verificar si el cluster tiene configurada la clave de "entitlement".
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.ibm_container_cluster[name]

    object.get(cluster, "entitlement", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_container_cluster.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'entitlement' attribute should be defined for clusters running IBM Entitled Software",
        "keyActualValue": "'entitlement' attribute is missing",
    }
}