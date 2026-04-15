package Cx

import data.generic.common as common_lib

# CASO 1: El bloque 'parameters' está ausente.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.ibm_resource_instance[name]
    resource.service == "cloudantnosqldb"

    object.get(resource, "parameters", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_resource_instance", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Cloudant instance should have a 'parameters' block containing 'key_protect_key'",
        "keyActualValue": "The 'parameters' block is missing (using default encryption)",
    }
}

# CASO 2: El bloque 'parameters' existe pero falta 'key_protect_key'.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.ibm_resource_instance[name]
    resource.service == "cloudantnosqldb"

    resource.parameters
    object.get(resource.parameters, "key_protect_key", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s.parameters", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_resource_instance", name, "parameters"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Cloudant 'parameters' should contain 'key_protect_key' with a valid Key Protect CRN",
        "keyActualValue": "'key_protect_key' is missing within the parameters map",
    }
}