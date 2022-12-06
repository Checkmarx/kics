package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	pubsub_topic := input.document[i].resource.google_pubsub_topic[name]

	bom_output = {
		"resource_type": "google_pubsub_topic",
		"resource_name": tf_lib.get_resource_name(pubsub_topic, name),
		"resource_accessibility": get_accessibility(name),
		"resource_encryption": check_encrytion(pubsub_topic),
		"resource_vendor": "GCP",
		"resource_category": "Messaging",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_pubsub_topic[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "google_pubsub_topic", name], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(resource) = enc_status {
	not common_lib.valid_key(resource, "kms_key_name")
	enc_status := "encrypted"
} else = enc_status {
	enc_status := "unencrypted"
}

get_accessibility(topic_name) = accessibility_status{
 	iam_binding :=	input.document[i].resource.google_pubsub_topic_iam_binding[_]
	topicRefArray := split(iam_binding.topic, ".")
	topicRefArray[1] == topic_name
	iam_binding.role == "roles/pubsub.publisher"
	checkMembers(iam_binding)
	accessibility_status :="public"
} else = accessibility_status {
	iam_binding :=	input.document[i].resource.google_pubsub_topic_iam_member[_]
	topicRefArray := split(iam_binding.topic, ".")
	topicRefArray[1] == topic_name
	iam_binding.role == "roles/pubsub.publisher"
	checkMembers(iam_binding)
	accessibility_status := "public"
} else = accessibility_status{
	accessibility_status := "unknown"
}	

consideredPublicPolicyMembers := {"allUsers","allAuthenticatedUsers"}

checkMembers(resource) {
	common_lib.valid_key(resource, "members")
	equalsOrInArray(resource.members, consideredPublicPolicyMembers[_])
} else {
	common_lib.valid_key(resource, "member")
	equalsOrInArray(resource.member, consideredPublicPolicyMembers[_])
}

equalsOrInArray(field, value) {
	is_string(field)
	field == value
}

equalsOrInArray(field, value) {
	is_array(field)
	field[i] == value
}
