package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	msk_cluster := input.document[i].resource.aws_msk_cluster[name]
	problems := checkEncryption(msk_cluster)
	problems != "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_msk_cluster",
		"resourceName": tf_lib.get_specific_resource_name(msk_cluster, "aws_msk_cluster", name),
		"searchKey": getSearchKey(problems, name),
		"issueType": getIssueType(problems),
		"keyExpectedValue": "Should have 'rule.encryption_info' and, if 'rule.encryption_info.encryption_in_transit' is assigned, 'in_cluster' should be 'true' and 'client_broker' should be TLS",
		"keyActualValue": "'rule.encryption_info' is unassigned or property 'in_cluster' is 'false' or property 'client_broker' is not 'TLS'",
	}
}

checkEncryption(msk_cluster) = ".encryption_in_transit.in_cluster,encryption_in_transit.client_broker" {
	encryptionInTransit = msk_cluster.encryption_info.encryption_in_transit
	encryptionInTransit.client_broker != "TLS"
	encryptionInTransit.in_cluster == false
} else = ".encryption_info.encryption_in_transit.client_broker" {
	encryptionInTransit = msk_cluster.encryption_info.encryption_in_transit
	encryptionInTransit.client_broker != "TLS"
} else = ".encryption_info.encryption_in_transit.in_cluster" {
	encryptionInTransit = msk_cluster.encryption_info.encryption_in_transit
	encryptionInTransit.in_cluster == false
} else = "" {
	not msk_cluster.encryption_info
} else = "none" {
	true
}

getSearchKey(problems, name) = str {
	problemsSplited := split(problems, ",")
	count(problemsSplited) == 2
	defaultSearchValue := sprintf("msk_cluster[%s].encryption_info", [name])
	str := concat(" and ", [concat("", [defaultSearchValue, problemsSplited[0]]), concat("", [defaultSearchValue, problemsSplited[1]])])
} else = str {
	defaultSearchValue := sprintf("msk_cluster[%s]", [name])
	str := concat("", [defaultSearchValue, problems])
}

getIssueType(problems) = "MissingAttribute" {
	problems == ""
} else = "IncorrectValue" {
	true
}
