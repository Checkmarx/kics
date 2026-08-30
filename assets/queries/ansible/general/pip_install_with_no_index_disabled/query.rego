package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
    task := ansLib.tasks[id][t]
    modules := {"ansible.builtin.pip", "pip"}
    mod := modules[m]
    pip_task := task[mod]
    ansLib.checkState(pip_task)

    # extra_args contains --extra-index-url without --require-hashes
    extra_args := pip_task.extra_args
    is_string(extra_args)
    contains(extra_args, "--extra-index-url")
    not contains(extra_args, "--require-hashes")

    result := {
        "documentId": id,
        "resourceType": mod,
        "resourceName": task.name,
        "searchKey": sprintf("name={{%s}}.{{%s}}.extra_args", [task.name, mod]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("%s using --extra-index-url should also specify --require-hashes", [mod]),
        "keyActualValue": sprintf("%s uses --extra-index-url without --require-hashes, allowing dependency confusion attacks", [mod]),
        "searchLine": common_lib.build_search_line(["playbooks", t, mod, "extra_args"], []),
    }
}
