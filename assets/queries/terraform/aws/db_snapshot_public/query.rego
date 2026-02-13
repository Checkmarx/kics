package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_db_snapshot[name]
    common_lib.valid_key(resource, "shared_accounts")
    resource.shared_accounts[_] == "all"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_db_snapshot",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_db_snapshot[{{%s}}].shared_accounts", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_db_snapshot", name, "shared_accounts"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "aws_db_snapshot.shared_accounts should not include 'all'",
        "keyActualValue": "aws_db_snapshot.shared_accounts includes 'all'",
        "remediation": json.marshal({
            "before": "shared_accounts = [\"all\"]",
            "after": "shared_accounts = []"
        }),
        "remediationType": "replacement",
    }
}

