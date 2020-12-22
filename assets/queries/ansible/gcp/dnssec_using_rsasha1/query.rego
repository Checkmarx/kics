package Cx

CxPolicy [ result ] {
  document := input.document[i]
  task := getTasks(document)[t]

  dnssec_config := task["google.cloud.gcp_dns_managed_zone"].dnssec_config
  lower(dnssec_config.defaultKeySpecs.algorithm) == "rsasha1"

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.defaultKeySpecs.algorithm", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'dnssec_config.defaultKeySpecs.algorithm' is not equal to 'rsasha1'",
                "keyActualValue": 	"'dnssec_config.defaultKeySpecs.algorithm' is equal to 'rsasha1'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}