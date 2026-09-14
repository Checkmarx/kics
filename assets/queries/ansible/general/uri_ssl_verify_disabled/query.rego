package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
    task := ansLib.tasks[id][t]
    modules := {"ansible.builtin.uri", "uri"}
    mod := modules[m]
    uri_task := task[mod]
    ansLib.checkState(uri_task)

    uri_task.validate_certs == false

    result := {
        "documentId": id,
        "resourceType": mod,
        "resourceName": task.name,
        "searchKey": sprintf("name={{%s}}.{{%s}}.validate_certs", [task.name, mod]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("%s.validate_certs should be true or omitted (defaults to true)", [mod]),
        "keyActualValue": sprintf("%s.validate_certs is false, disabling SSL certificate validation", [mod]),
        "searchLine": common_lib.build_search_line(["playbooks", t, mod, "validate_certs"], []),
    }
}
