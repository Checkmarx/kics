package Cx

CxPolicy [ result ] {
  	document := input.document[i]
  	task := getTasks(document)[t]
    firewall_rule := task["azure_rm_rediscachefirewallrule"]

  	not privateIP(firewall_rule.start_ip_address)
    not privateIP(firewall_rule.end_ip_address)

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'azure_rm_rediscachefirewallrule' ip range is private",
                "keyActualValue": 	"'azure_rm_rediscachefirewallrule' ip range is public"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

privateIP(ip) {
	private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
	net.cidr_contains(private_ips[_], ip)
}
