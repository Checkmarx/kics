package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    doc := input.document[i]
    contact := doc.resource.google_essential_contacts_contact[name]

    contacts_not_configured_for_org(contact, i, doc)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_essential_contacts_contact",
        "resourceName": tf_lib.get_resource_name(contact, name),
        "searchKey": sprintf("google_essential_contacts_contact[%s].notification_category_subscription_field", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'notification_category_subscription_field' should have 'ALL' value or all 'LEGAL', 'SUSPENSION', 'TECHNICAL' and 'SECURITY' values defined",
        "keyActualValue": "'notification_category_subscription_field' does not have 'ALL' value or all 'LEGAL', 'SUSPENSION', 'TECHNICAL' and 'SECURITY' values defined",
        "searchLine": common_lib.build_search_line(["resource", "google_essential_contacts_contact", name, "notification_category_subscriptions"], [])
    }
}

contacts_not_configured_for_org(resource, document_index, document) {
    is_at_organization_level(resource, document_index, document)
    not all_in_list(resource.notification_category_subscriptions)
}

all_in_list(list) {
    common_lib.inArray(list, "LEGAL")
    common_lib.inArray(list, "SECURITY")
    common_lib.inArray(list, "SUSPENSION")
    common_lib.inArray(list, "TECHNICAL")
} else {
    common_lib.inArray(list, "ALL")
}

# check if the contact is at organization level through the parent field 
is_at_organization_level(resource, document_index, document) {
    resource_type := split(resource.parent, "/")[0]
    resource_type == "organizations"
} else { # case when the parent field references the cases when a data source of type google_organization
    resource_type := split(resource.parent, ".")[1]
    resource_type == "google_organization"
    data_source_name := split(resource.parent, ".")[2]
    data_source := document.data.google_organization[ds_name]
    data_source_name == ds_name
}