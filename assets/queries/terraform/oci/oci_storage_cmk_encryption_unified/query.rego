package Cx

targets := {
    "oci_objectstorage_bucket",
    "oci_core_volume",
    "oci_core_boot_volume",
    "oci_file_storage_file_system"
}

# CASO 1: Falta el atributo kms_key_id (Usa claves gestionadas por Oracle)
CxPolicy[result] {
    doc := input.document[i]
    
    resource := doc.resource[resource_type][name]
    targets[resource_type]

    object.get(resource, "kms_key_id", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s' should have 'kms_key_id' defined with a Vault Key OCID", [name]),
        "keyActualValue": "'kms_key_id' is missing (using Oracle-managed keys)",
    }
}

# CASO 2: El atributo existe pero está vacío
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource[resource_type][name]
    targets[resource_type]

    resource.kms_key_id
    resource.kms_key_id == ""

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s.kms_key_id", [resource_type, name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'kms_key_id' should not be empty",
        "keyActualValue": "'kms_key_id' is empty",
    }
}