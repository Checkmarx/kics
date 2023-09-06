package Cx

import data.generic.ansible as ansLib

module_to_folder = {
    "copy": "files",
    "win_copy": "files",
    "template": "templates",
    "win_template": "win_templates",
	"ansible.builtin.template": "templates",
	"ansible.builtin.copy": "files",
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	folder := module_to_folder[m]
	copyOrTemplate := task[m]
	ansLib.checkState(copyOrTemplate)

	relative_path := sprintf("../%s", [folder])
	contains(copyOrTemplate.src, relative_path)

	result := {
		"documentId": id,
		"resourceType": m,
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.src", [task.name, m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.src should not be a relative path", [m]),
		"keyActualValue": sprintf("%s.src is a relative path", [m]),
	}
}

