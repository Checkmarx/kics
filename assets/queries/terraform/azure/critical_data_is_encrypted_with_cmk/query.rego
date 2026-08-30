package Cx 

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    storage_account := input.document[i].resource.azurerm_storage_account[name_sa]
    not common_lib.valid_key(input.document[i].resource, "azurerm_storage_account_customer_managed_key")

    res := get_res_storage_account(storage_account, name_sa)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(storage_account, name_sa),
        "searchKey": res["sk"],
        "searchLine": res["sl"],
        "issueType": "MissingAttribute",
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "remediation": res["rem"],
        "remediationType": res["rtype"],
    }
}

CxPolicy[result] { # case when both resource types defined but the azurerm_storage_account_customer_managed_key point incorrectly to azurerm_storage_account
    storage_account := input.document[i].resource.azurerm_storage_account[name_sa]
    storage_account_cmk := input.document[i].resource.azurerm_storage_account_customer_managed_key[name_sa_cmk]

    not name_sa == split(storage_account_cmk.storage_account_id, ".")[1]
    clean_storage_id := trim_suffix(trim_prefix(storage_account_cmk.storage_account_id, "${"), "}")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account_customer_managed_key",
        "resourceName": tf_lib.get_resource_name(storage_account_cmk, name_sa_cmk),
        "searchKey": sprintf("azurerm_storage_account_customer_managed_key[%s].storage_account_id", [name_sa_cmk]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_customer_managed_key", name_sa_cmk, "storage_account_id"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'storage_account_id' is referencing an 'azurerm_storage_account' that doesn't exist",
        "keyActualValue": "'storage_account_id' is not referencing an existent 'azurerm_storage_account'",
        "remediation": json.marshal({
            "before": sprintf("%s", [clean_storage_id]),
            "after": sprintf("azurerm_storage_account.%s.id", [name_sa])
        }),
        "remediationType": "replacement"
    }
}

CxPolicy[result] { # azurerm_storage_account_customer_managed_key resource defined and referencing a azurerm_storage_account resource that does not exist at all
    storage_account_cmk := input.document[i].resource.azurerm_storage_account_customer_managed_key[name_sa_cmk]
    not common_lib.valid_key(input.document[i].resource, "azurerm_storage_account")
    common_lib.valid_key(storage_account_cmk, "storage_account_id")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account_customer_managed_key",
        "resourceName": tf_lib.get_resource_name(storage_account_cmk, name_sa_cmk),
        "searchKey": sprintf("azurerm_storage_account_customer_managed_key[%s].storage_account_id", [name_sa_cmk]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_customer_managed_key", name_sa_cmk, "storage_account_id"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'storage_account_id' is referencing an 'azurerm_storage_account' that doesn't exist",
        "keyActualValue": "'storage_account_id' is not referencing an existent 'azurerm_storage_account'",
        "remediation": null,
        "remediationType": null
    }
}

get_res_storage_account(storage_account, name) = res { # key_vault_key_id field not defined
    common_lib.valid_key(storage_account, "customer_managed_key")
    not common_lib.valid_key(storage_account.customer_managed_key, "key_vault_key_id")

    res := {
        "sk": sprintf("azurerm_storage_account[%s].customer_managed_key", [name]),
        "sl": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "customer_managed_key"], []),
        "kav": "'key_vault_key_id' is not defined inside the 'customer_managed_key' block",
        "kev": "'key_vault_key_id' must be defined inside the 'customer_managed_key' block",
        "rem": "\nkey_vault_key_id = \"azure\"\n",
        "rtype": "addition"
    }
} else = res { # customer_managed_key block not defined
    not common_lib.valid_key(storage_account, "customer_managed_key")
    res := {
        "sk": sprintf("azurerm_storage_account[%s]", [name]),
        "kav": "'key_vault_key_id' is not defined inside the 'customer_managed_key' block",
        "kev": "'key_vault_key_id' must be defined inside the 'customer_managed_key' block",
        "sl": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "customer_managed_key"], []),
        "rem": "customer_managed_key {\n\t\tkey_vault_key_id = \"azure\"\n\t}",
        "rtype": "addition"
    }
}