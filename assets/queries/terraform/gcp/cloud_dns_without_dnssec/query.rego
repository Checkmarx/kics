package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.google_dns_managed_zone[name]
    dnssec_config := resource.dnssec_config
    is_array(dnssec_config)
    dnssec_config[_].state != "on"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'dnssec_config.state' is equal 'on'",
                "keyActualValue": 	"'dnssec_config.state' is not equal 'on'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.google_dns_managed_zone[name]
    dnssec_config := resource.dnssec_config
    is_object(dnssec_config)
    dnssec_config.state != "on"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'dnssec_config.state' is equal 'on'",
                "keyActualValue": 	"'dnssec_config.state' is not equal 'on'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}