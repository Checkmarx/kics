package Cx

# REGLA: Detectar instancias de LogDNA que no tienen un recurso de archivado asociado.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.resource.ibm_logdna_instance[instance_name]

    matching_archives := [archive |
        archive := input.document[_].resource.ibm_logdna_archive[_]
        contains(archive.instance_id, instance_name)
    ]

    count(matching_archives) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_logdna_instance.%s", [instance_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "ibm_logdna_instance should have an associated ibm_logdna_archive resource",
        "keyActualValue": "ibm_logdna_instance does not have an associated ibm_logdna_archive resource",
    }
}