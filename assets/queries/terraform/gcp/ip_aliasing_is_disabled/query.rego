package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.ip_allocation_policy
	not resource.networking_mode

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attributes 'ip_allocation_policy' and 'networking_mode' are defined",
		"keyActualValue": "Attributes 'ip_allocation_policy' and 'networking_mode' are undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.ip_allocation_policy
	resource.networking_mode

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'ip_allocation_policy' is defined",
		"keyActualValue": "Attribute 'ip_allocation_policy' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.ip_allocation_policy
	resource.networking_mode == "ROUTES"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'networking_mode' is VPC_NATIVE",
		"keyActualValue": "Attribute 'networking_mode' is ROUTES",
	}
}
