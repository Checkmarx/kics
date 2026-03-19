package Cx

# REGLA 1: Missing (Global)
# No existe ningún recurso 'oci_ons_notification_topic' en todo el documento.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    all_topics := [topic |
        topic := input.document[_].resource.oci_ons_notification_topic[_]
    ]

    count(all_topics) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "issueType": "MissingAttribute",
        "keyExpectedValue": "At least one 'oci_ons_notification_topic' resource should exist",
        "keyActualValue": "No 'oci_ons_notification_topic' resource was found",
    }
}

# REGLA 2: Orphan Topic (Local)
# Existe un tópico, pero ninguna suscripción apunta a él.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.resource.oci_ons_notification_topic[topic_name]

    matching_subscriptions := [sub |
        sub := input.document[_].resource.oci_ons_subscription[_]
        contains(sub.topic_id, topic_name)
    ]

    count(matching_subscriptions) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_ons_notification_topic.%s", [topic_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'oci_ons_notification_topic' should have at least one associated 'oci_ons_subscription'",
        "keyActualValue": "'oci_ons_notification_topic' has no subscriptions",
    }
}