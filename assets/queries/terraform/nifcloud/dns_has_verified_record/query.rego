package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	dnsRecord := input.document[i].resource.nifcloud_dns_record[name]
	contains(dnsRecord.record, "nifty-dns-verify=")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_dns_record",
		"resourceName": tf_lib.get_resource_name(dnsRecord, name),
		"searchKey": sprintf("nifcloud_dns_record[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Verified records should be removed from 'nifcloud_dns_record[%s]'.", [name]),
		"keyActualValue": sprintf("'nifcloud_dns_record[%s]' has risk of DNS records being used by others.", [name]),
	}
}
