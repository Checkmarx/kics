package Cx

# Ingress whitelist-source-range annotation set to 0.0.0.0/0 or ::/0 allows all IPs.
CxPolicy[result] {
	document := input.document[i]
	document.kind == "Ingress"
	metadata := document.metadata

	whitelist := metadata.annotations["nginx.ingress.kubernetes.io/whitelist-source-range"]
	open_cidr_in_whitelist(whitelist)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.metadata.annotations.nginx.ingress.kubernetes.io/whitelist-source-range", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Ingress '%s' whitelist-source-range should restrict access to specific IP ranges", [metadata.name]),
		"keyActualValue": sprintf("Ingress '%s' whitelist-source-range is set to '%s', allowing access from all IP addresses", [metadata.name, whitelist]),
	}
}

open_cidr_in_whitelist(whitelist) {
	contains(whitelist, "0.0.0.0/0")
}

open_cidr_in_whitelist(whitelist) {
	contains(whitelist, "::/0")
}
