package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[_][_]
	modulesFirewall := {"google.cloud.gcp_compute_firewall", "gcp_compute_firewall"}
	firewall := task[modulesFirewall[_]]
	ans_lib.checkState(firewall)

	is_ingress(firewall)
	regex.match("[0-9]+-[0-9]+", firewall.allowed[_].ports[_])
	firewall.allowed[_].ports[_] != "0-65535"

	tk := ans_lib.tasks[id][_]
	modulesCompute := {"google.cloud.gcp_compute_network", "gcp_compute_network"}
	computeNetwork := tk[modulesCompute[m]]
	ans_lib.checkState(computeNetwork)
	firewall.network == sprintf("{{ %s }}", [tk.register])


	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [tk.name, modulesCompute[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is not using a firewall rule that allows access to port range", [modulesCompute[m]]),
		"keyActualValue": sprintf("'%s' is using a firewall rule that allows access to port range", [modulesCompute[m]]),
	}
}

is_ingress(firewall) {
	not common_lib.valid_key(firewall, "direction")
} else {
	firewall.direction == "INGRESS"
}
