package Cx

import data.generic.common as common_lib
import data.generic.ansible as ansLib

modules := {"amazon.aws.ec2_instance"}

CxPolicy[result] {
    task := ansLib.tasks[id][t]
	ec2 := task[modules[m]]

    common_lib.valid_key(ec2, "metadata_options")
    common_lib.valid_key(ec2.metadata_options, "http_endpoint")
    not ec2.metadata_options.http_endpoint == "enabled"

    result := {
        "documentId": input.document[i].id,
        "resourceType": modules[m],
        "resourceName": task.name,
        "searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
        "searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "metadata_options", "http_endpoint"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s.metadata_options.http_endpoint' should be defined to 'enabled'", [modules[m]]),
        "keyActualValue": sprintf("'%s.metadata_options.http_endpoint' is not defined defined to 'enabled'", [modules[m]]),
    }
}

CxPolicy[result] {
    task := ansLib.tasks[id][t]
	modules := {"amazon.aws.ec2_instance"}
	ec2 := task[modules[m]]

    res := http_tokens_undefined_or_not_required(ec2, m, t, task)

    result := {
        "documentId": input.document[i].id,
        "resourceType": modules[m],
        "resourceName": task.name,
        "searchKey": res["sk"],
        "searchLine": res["sl"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
    }
}

http_tokens_undefined_or_not_required(ec2, name, t, task) = res {
    not common_lib.valid_key(ec2, "metadata_options")
    res := {
        "kev": sprintf("'%s.metadata_options' should be defined with 'http_tokens' field set to 'required'", [modules[name]]),
        "kav": sprintf("'%s.metadata_options' is not defined", [modules[name]]),
        "sk": sprintf("name={{%s}}.{{%s}}", [task.name, modules[name]]),
        "sl": common_lib.build_search_line(["playbooks", t, modules[name]], []),
        "it": "MissingAttribute",
    }
} else = res {
    common_lib.valid_key(ec2, "metadata_options")
    not common_lib.valid_key(ec2.metadata_options, "http_tokens")

    res := {
        "kev": sprintf("'%s.metadata_options.http_tokens' should be defined to 'required'", [modules[name]]),
        "kav": sprintf("'%s.metadata_options.http_tokens' is not defined", [modules[name]]),
        "sk": sprintf("name={{%s}}.{{%s}}.metadata_options", [task.name, modules[name]]),
        "sl": common_lib.build_search_line(["playbooks", t, modules[name], "metadata_options"], []),
        "it": "MissingAttribute",
    }
} else = res {
    common_lib.valid_key(ec2.metadata_options, "http_tokens")
    not ec2.metadata_options.http_tokens == "required"

    res := {
        "kev": sprintf("'%s.metadata_options.http_tokens' should be defined to 'required'", [modules[name]]),
        "kav": sprintf("'%s.metadata_options.http_tokens' is not defined to 'required'", [modules[name]]),
        "sk": sprintf("name={{%s}}.{{%s}}.metadata_options.http_tokens", [task.name, modules[name]]),
        "sl": common_lib.build_search_line(["playbooks", t, modules[name], "matadata_options", "http_tokens"], []),
        "it": "IncorrectValue",
    }
}