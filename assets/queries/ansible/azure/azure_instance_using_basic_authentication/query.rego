package Cx

import future.keywords.if
import data.generic.common as common_lib

CxPolicy[result] {
	vm := input.document[i].playbooks[k].azure_rm_virtualmachine
	is_linux_vm(vm)
	res := get_results(vm, ["playbooks", k, "azure_rm_virtualmachine"])
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azure_rm_virtualmachine",
		"resourceName": vm.name,
		"searchKey": res.searchKey,
		"issueType": res.issueType,
		"keyExpectedValue": res.keyExpectedValue,
		"keyActualValue": res.keyActualValue,
		"searchLine": res.searchLine,
	}
}

CxPolicy[result] {
	vm := input.document[i].playbooks[k].tasks[y].azure_rm_virtualmachine
	is_linux_vm(vm)
	res := get_results(vm, ["playbooks", k, "tasks", y, "azure_rm_virtualmachine"])
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azure_rm_virtualmachine",
		"resourceName": vm.name,
		"searchKey": res.searchKey,
		"issueType": res.issueType,
		"keyExpectedValue": res.keyExpectedValue,
		"keyActualValue": res.keyActualValue,
		"searchLine": res.searchLine,
	}
}

get_results(vm, path) = res {										# both "ssh_password_enabled" and "linux_config" undefined
	not common_lib.valid_key(vm, "ssh_password_enabled")
	not common_lib.valid_key(vm, "linux_config")
	res := {
		"searchKey": sprintf("azure_rm_virtualmachine.%s", [vm.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should set 'ssh_password_enabled' to false and 'linux_config.disable_password_authentication' to true", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s].ssh_password_enabled' and 'linux_config' are both undefined", [vm.name]),
		"searchLine": common_lib.build_search_line(path, []),
	}
}  else = res {														# "ssh_password_enabled" undefined with "linux_config" missing "disable_password_authentication" field
	not common_lib.valid_key(vm, "ssh_password_enabled")
	common_lib.valid_key(vm, "linux_config")
	not common_lib.valid_key(vm.linux_config, "disable_password_authentication")
	res := {
		"searchKey": sprintf("azure_rm_virtualmachine.%s.linux_config", [vm.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should set 'ssh_password_enabled' to false and 'linux_config.disable_password_authentication' to true", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s].ssh_password_enabled' and 'linux_config.disable_password_authentication' are both undefined", [vm.name]),
		"searchLine": common_lib.build_search_line(path, ["linux_config"]),
	}
} else = res {													# "ssh_password_enabled" undefined with "linux_config.disable_password_authentication" set to false
	not common_lib.valid_key(vm, "ssh_password_enabled")
	common_lib.valid_key(vm, "linux_config")
	vm.linux_config.disable_password_authentication == false
	res := {
		"searchKey": sprintf("azure_rm_virtualmachine.%s.linux_config.disable_password_authentication", [vm.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should set 'ssh_password_enabled' to false and 'linux_config.disable_password_authentication' to true", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s].ssh_password_enabled' is undefined and 'linux_config.disable_password_authentication' is set to false", [vm.name]),
		"searchLine": common_lib.build_search_line(path, ["linux_config", "disable_password_authentication"]),
	}
} else = res {															# "ssh_password_enabled" set to true, "linux_config" undefined
	vm.ssh_password_enabled == true
	not common_lib.valid_key(vm, "linux_config")
	res := {
		"searchKey": sprintf("azure_rm_virtualmachine.%s.ssh_password_enabled", [vm.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should set 'ssh_password_enabled' to false and 'linux_config.disable_password_authentication' to true", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s].ssh_password_enabled' is set to true and 'linux_config' is undefined", [vm.name]),
		"searchLine": common_lib.build_search_line(path, ["ssh_password_enabled"]),
	}
} else = res {													# "ssh_password_enabled" set to true with "linux_config" missing "disable_password_authentication" field
	vm.ssh_password_enabled == true
	common_lib.valid_key(vm, "linux_config")
	not common_lib.valid_key(vm.linux_config, "disable_password_authentication")
	res := {
		"searchKey": sprintf("azure_rm_virtualmachine.%s.ssh_password_enabled", [vm.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should set 'ssh_password_enabled' to false and 'linux_config.disable_password_authentication' to true", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s].ssh_password_enabled' is true and 'linux_config.disable_password_authentication' is undefined", [vm.name]),
		"searchLine": common_lib.build_search_line(path, ["ssh_password_enabled"]),
	}
} else = res {															# "ssh_password_enabled" set to true with "linux_config.disable_password_authentication" set to false
	vm.ssh_password_enabled == true
	common_lib.valid_key(vm, "linux_config")
	vm.linux_config.disable_password_authentication == false
	res := {
		"searchKey": sprintf("azure_rm_virtualmachine.%s.ssh_password_enabled", [vm.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azure_rm_virtualmachine[%s]' should set 'ssh_password_enabled' to false and 'linux_config.disable_password_authentication' to true", [vm.name]),
		"keyActualValue": sprintf("'azure_rm_virtualmachine[%s].ssh_password_enabled' is set to true and 'linux_config.disable_password_authentication' to false", [vm.name]),
		"searchLine": common_lib.build_search_line(path, ["ssh_password_enabled"]),
	}
}

is_linux_vm(vm) {
	lower(vm.os_type) == "linux"
} else {
	not common_lib.valid_key(vm, "os_type")
}