package Cx

# REGLA: Detectar clústeres de IKS sin configuración de monitorización asociada.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.resource.ibm_container_cluster[cluster_name]

    matching_configs := [config |
        config := input.document[_].resource.ibm_ob_monitoring_config[_]
        contains(config.scope, cluster_name)
    ]

    count(matching_configs) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_container_cluster.%s", [cluster_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "ibm_container_cluster should have an associated ibm_ob_monitoring_config resource",
        "keyActualValue": "ibm_container_cluster does not have an associated ibm_ob_monitoring_config resource",
    }
}