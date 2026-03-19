package Cx

# REGLA: Verificar si el cluster de Kubernetes tiene configuradas las alertas de vulnerabilidad.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.ibm_container_cluster[name]

    va_notifications := [n | n := input.document[_].resource.ibm_container_va_notification[_]]

    count(va_notifications) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_container_cluster.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "A 'ibm_container_va_notification' resource should be defined to alert on image vulnerabilities",
        "keyActualValue": "Vulnerability Advisor notifications are missing for this cluster environment",
    }
}