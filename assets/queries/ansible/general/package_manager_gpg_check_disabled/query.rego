package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
    task := ansLib.tasks[id][t]
    modules := {"ansible.builtin.yum", "yum", "ansible.builtin.dnf", "dnf"}
    mod := modules[m]
    pkg_task := task[mod]
    ansLib.checkState(pkg_task)

    pkg_task.disable_gpg_check == true

    result := {
        "documentId": id,
        "resourceType": mod,
        "resourceName": task.name,
        "searchKey": sprintf("name={{%s}}.{{%s}}.disable_gpg_check", [task.name, mod]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("%s.disable_gpg_check should be false or omitted (defaults to false)", [mod]),
        "keyActualValue": sprintf("%s.disable_gpg_check is true, skipping GPG signature verification", [mod]),
        "searchLine": common_lib.build_search_line(["playbooks", t, mod, "disable_gpg_check"], []),
    }
}
