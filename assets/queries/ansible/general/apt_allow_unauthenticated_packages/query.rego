package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
    task := ansLib.tasks[id][t]
    modules := {"ansible.builtin.apt", "apt"}
    mod := modules[m]
    apt_task := task[mod]
    ansLib.checkState(apt_task)

    apt_task.allow_unauthenticated == true

    result := {
        "documentId": id,
        "resourceType": mod,
        "resourceName": task.name,
        "searchKey": sprintf("name={{%s}}.{{%s}}.allow_unauthenticated", [task.name, mod]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("%s.allow_unauthenticated should be false or omitted (defaults to false)", [mod]),
        "keyActualValue": sprintf("%s.allow_unauthenticated is true, allowing unsigned packages to be installed", [mod]),
        "searchLine": common_lib.build_search_line(["playbooks", t, mod, "allow_unauthenticated"], []),
    }
}
