package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.iam_group", "iam_group"}

CxPolicy[result] {
    task := ansLib.tasks[id][t]
    iam_group := task[modules[m]]
    ansLib.checkState(iam_group)

    not common_lib.valid_key(iam_group, "users")

    result := {
        "documentId": id,
        "resourceType": modules[m],
		"resourceName": task.name,
        "searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("%s.users should be defined and not null", [modules[m]]),
        "keyActualValue": sprintf("%s.users is undefined or null", [modules[m]]),
    }
}
