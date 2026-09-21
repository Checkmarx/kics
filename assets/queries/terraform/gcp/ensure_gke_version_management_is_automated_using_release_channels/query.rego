package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]

    res := get_res(resource, name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": res["sk"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "searchLine": res["sl"],
        "remediation": res["remediation"],
        "remediationType": res["remediationType"],
    }
}

get_res(resource, name) = res {
    not common_lib.valid_key(resource, "release_channel")

    res := {
        "sk": sprintf("google_container_cluster[%s]", [name]),
        "it": "MissingAttribute",
        "kev": "'channel' should be defined to 'STABLE' or 'REGULAR' inside the 'release_channel' block",
        "kav": "'release_channel' block is not defined",
        "sl": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
        "remediation": "release_channel {\n\t\tchannel = \"REGULAR\"\n\t}\n",
        "remediationType": "addition",
    }
} else = res {
    not is_release_channel_correctly_defined(resource.release_channel.channel)

    res := {
        "sk": sprintf("google_container_cluster[%s].release_channel.channel", [name]),
        "it": "IncorrectValue",
        "kev": "'channel' should be defined to 'STABLE' or 'REGULAR' inside the 'release_channel' block",
        "kav": sprintf("'release_channel.channel' is defined to '%s'", [resource.release_channel.channel]),
        "sl": common_lib.build_search_line(["resource", "google_container_cluster", name, "release_channel", "channel"], []),
        "remediation": json.marshal({
            "before": sprintf("%s", [resource.release_channel.channel]),
            "after": "REGULAR"
        }),
        "remediationType": "replacement",
    }
}

is_release_channel_correctly_defined("STABLE") = true
is_release_channel_correctly_defined("REGULAR") = true