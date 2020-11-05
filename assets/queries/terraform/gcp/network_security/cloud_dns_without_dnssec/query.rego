package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.google_dns_managed_zone[name]
    dnssec_config := resource.dnssec_config
    is_array(dnssec_config)
    dnssec_config[_].state != "on"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'dnssec_config.state' is equal 'on'",
                "keyActualValue": 	"'dnssec_config.state' is not equal 'on'"
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.google_dns_managed_zone[name]
    dnssec_config := resource.dnssec_config
    is_object(dnssec_config)
    dnssec_config.state != "on"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'dnssec_config.state' is equal 'on'",
                "keyActualValue": 	"'dnssec_config.state' is not equal 'on'"
              }
}