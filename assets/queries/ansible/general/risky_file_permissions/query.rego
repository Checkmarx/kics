package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib


CxPolicy[result] {
	task := ansLib.tasks[id][e]
    action := task[m]
    action.mode == "preserve"
    
    modules_with_preserve := ["copy", "template"]
    count([x | x := modules_with_preserve[mp]; x == m]) == 0
    
	result := {
		"documentId": id,
		"resourceType": m,
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s does not allow setting 'preserve' value for 'mode' key", [m]),
		"keyActualValue": sprintf("'Mode' key of %s is set to 'preserve'", [m]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][_]
    modules := [
        "archive", "community.general.archive", "assemble", "ansible.builtin.assemble", "copy", "ansible.builtin.copy", "file", "ansible.builtin.file", 
        "get_url", "ansible.builtin.get_url", "template", "ansible.builtin.template",
    ]
	action := task[modules[m]]

    state := object.get(action, "state", "none")
	state != "absent"
    state != "link"

	not common_lib.valid_key(action, "recurse")
    not file_module(action, modules[m])
    
    not common_lib.valid_key(action, "mode")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("All the permissions set in %s about creating files/directories", [modules[m]]),
		"keyActualValue": sprintf("There are some permissions missing in %s and might create directory/file", [modules[m]]),
	}
}


CxPolicy[result] {
	task := ansLib.tasks[id][_]
    modules := {
        "blockinfile": false,
        "ansible.builtin.blockinfile": false,
        "htpasswd": true,
        "community.general.htpasswd": true,
        "ini_file": true,
        "community.general.ini_file": true,
        "lineinfile": false,
        "ansible.builtin.lineinfile": false,
    }

	action := task[m]
    not common_lib.valid_key(action, "mode")

    bool := modules[m]
    object.get(action, "create", bool) == true

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s 'create' key should set to 'false' or 'mode' key should be defined", [m]),
		"keyActualValue": sprintf("%s 'create' key is set to 'true' and 'mode' key is not defined", [m]),
	}
}

file_module(action, module_name){
    module_name == "file"
    object.get(action, "state", "file") == "file"
} else {
	module_name == "ansible.builtin.file"
    object.get(action, "state", "file") == "file"
}
