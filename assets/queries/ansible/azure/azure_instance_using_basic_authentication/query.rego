package Cx

import future.keywords.if

CxPolicy[result] {
	vm := input.document[i].playbooks[k].azure_rm_virtualmachine
    is_linux_vm(vm)
    not vm.ssh_password_enabled == false
    not vm.linux_config.disable_password_authentication == false
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azure_rm_virtualmachine",
		"resourceName": vm.name,
		"searchKey": sprintf("azure_rm_virtualmachine[%s].ssh_public_keys", [vm.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should be using SSH keys for authentication", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s]' is using username and password for authentication", [vm.name]),
	}
}

is_linux_vm(vm) {
    lower(vm.os_type) == "linux"
} else {
    not vm.os_type
}
