package Cx

import data.generic.common as common_lib

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { not is_array(x) }

# CASE 1: Bloque 'boot_volume' totalmente missing.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.ibm_is_instance[name]

    not instance.boot_volume

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_is_instance.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_is_instance", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'boot_volume' block should be defined with 'encryption' set to a CRN",
        "keyActualValue": "'boot_volume' block is missing (using default encryption)",
    }
}

# CASE 2: Bloque 'boot_volume' presente, but Missing 'encryption'.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.ibm_is_instance[name]

    boot_volumes := ensure_array(instance.boot_volume)
    boot_vol := boot_volumes[_]

    object.get(boot_vol, "encryption", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_is_instance.%s.boot_volume", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_is_instance", name, "boot_volume"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'boot_volume.encryption' attribute should be defined with a Key Protect/HPCS CRN",
        "keyActualValue": "'encryption' is missing in boot_volume (using default encryption)",
    }
}