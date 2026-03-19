package Cx

import future.keywords.in

auditable_resource_types := {
    "oci_core_instance",
    "oci_core_vcn",
    "oci_core_subnet",
    "oci_core_security_list",
    "oci_core_route_table",
    "oci_core_internet_gateway",
    "oci_core_nat_gateway",
    "oci_core_service_gateway",
    "oci_objectstorage_bucket",
    "oci_database_db_system",
    "oci_containerengine_cluster",
    "oci_functions_application",
    "oci_kms_vault",
    "oci_ons_notification_topic"
}

is_root_compartment(compartment_id) {
    contains(lower(compartment_id), "var.tenancy_ocid")
}
is_root_compartment(compartment_id) {
    contains(lower(compartment_id), "tenancy")
}

CxPolicy[result] {
    doc := input.document[i]
	
    some resource_type
    resources := doc.resource[resource_type]

    resource_type in auditable_resource_types

    some resource_name
    resource := resources[resource_name]

    compartment_id := object.get(resource, "compartment_id", "")
    compartment_id != ""

    is_root_compartment(compartment_id)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s.compartment_id", [resource_type, resource_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("Resource '%s' should be created in a child compartment, not the root compartment", [resource_name]),
        "keyActualValue": sprintf("Resource '%s' is created in the root compartment (tenancy)", [resource_name]),
    }
}