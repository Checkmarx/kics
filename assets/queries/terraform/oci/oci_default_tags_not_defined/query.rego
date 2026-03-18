package Cx

CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    all_default_tags := [tag |
        tag := input.document[_].resource.oci_identity_tag_default[_]
    ]

    count(all_default_tags) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "issueType": "MissingAttribute",
        "keyExpectedValue": "At least one 'oci_identity_tag_default' resource should exist to define a default tagging policy",
        "keyActualValue": "No 'oci_identity_tag_default' resource was found in the configuration",
    }
}