package Cx

import data.generic.common as common_lib

# CASO 1: Base de datos sin 'key_protect_key'.
CxPolicy[result] {
    doc := input.document[i]
    db := doc.resource.ibm_database[name]

    object.get(db, "key_protect_key", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_database.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_database", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'key_protect_key' attribute should be defined with a Key Protect/HPCS CRN",
        "keyActualValue": "'key_protect_key' is missing (using default provider-managed encryption)",
    }
}