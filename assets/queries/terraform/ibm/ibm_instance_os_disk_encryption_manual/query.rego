package Cx

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { not is_array(x) }

# CASO 1: Bloque 'boot_volume' totalmente ausente.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.ibm_is_instance[name]

    not instance.boot_volume

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_is_instance.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'boot_volume' block should be defined with 'encryption' set to a CRN",
        "keyActualValue": "'boot_volume' block is missing (using default encryption)",
    }
}

# CASO 2: Bloque 'boot_volume' presente, pero falta 'encryption'.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.ibm_is_instance[name]

    boot_volumes := ensure_array(instance.boot_volume)
    boot_vol := boot_volumes[_]

    object.get(boot_vol, "encryption", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_is_instance.%s.boot_volume", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'boot_volume.encryption' attribute should be defined with a Key Protect/HPCS CRN",
        "keyActualValue": "'encryption' is missing in boot_volume (using default encryption)",
    }
}