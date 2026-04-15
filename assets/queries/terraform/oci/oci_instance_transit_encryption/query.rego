package Cx

import data.generic.common as common_lib

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { is_object(x) }

# CASE 1: The block launch_options Exists, but la opción está explícitamente en FALSE.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.oci_core_instance[name]

    options := ensure_array(instance.launch_options)
    opt := options[_]

    opt.is_pv_encryption_in_transit_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_instance.%s.launch_options.is_pv_encryption_in_transit_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", name, "launch_options", "is_pv_encryption_in_transit_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_pv_encryption_in_transit_enabled' should be set to true",
        "keyActualValue": "'is_pv_encryption_in_transit_enabled' is set to false",
    }
}

# CASE 2: The block launch_options Exists, but Missing The attribute (default es false/inseguro).
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.oci_core_instance[name]

    options := ensure_array(instance.launch_options)
    opt := options[_]

    object.get(opt, "is_pv_encryption_in_transit_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_instance.%s.launch_options", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", name, "launch_options"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'is_pv_encryption_in_transit_enabled' should be defined and set to true",
        "keyActualValue": "'is_pv_encryption_in_transit_enabled' is missing",
    }
}

# CASE 3: Missing The block launch_options completo.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.oci_core_instance[name]

    not instance.launch_options

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_instance.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'launch_options' block with 'is_pv_encryption_in_transit_enabled = true' should be defined",
        "keyActualValue": "'launch_options' block is missing",
    }
}