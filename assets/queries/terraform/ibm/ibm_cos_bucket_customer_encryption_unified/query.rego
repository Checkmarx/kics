package Cx

# REGLA UNIFICADA: Verificación de Cifrado Gestionado por el Cliente en COS.
CxPolicy[result] {
    doc := input.document[i]
    bucket := doc.resource.ibm_cos_bucket[name]

    object.get(bucket, "key_protect", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cos_bucket.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'key_protect' attribute should be defined (required for CMK, BYOK, or KYOK)",
        "keyActualValue": "'key_protect' is missing (using default provider-managed encryption)",
    }
}