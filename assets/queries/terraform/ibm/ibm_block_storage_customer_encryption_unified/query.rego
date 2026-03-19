package Cx

# REGLA UNIFICADA: Cifrado Gestionado por el Cliente en Block Storage.
CxPolicy[result] {
    doc := input.document[i]
    volume := doc.resource.ibm_is_volume[name]

    object.get(volume, "encryption_key", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_is_volume.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'encryption_key' attribute should be defined (prerequisite for CMK, BYOK, or KYOK)",
        "keyActualValue": "'encryption_key' is missing (using default provider-managed encryption)",
    }
}